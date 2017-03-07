class SubmissionRepository
  def rejected
    Submission.where(rejected: true).order('created_at ASC')
  end

  def valid
    not_rejected.order('created_at ASC')
  end

  def to_rate
    with_rates_if_any
      .having('count("rates") < ?', Setting.get.required_rates_num)
      .order('created_at ASC')
  end

  def rated
    with_rates_if_any
      .having('count("rates") >= ?',  Setting.get.required_rates_num)
      .order('AVG(value) DESC')
  end

  def accepted
    rated.limit(Setting.get.available_spots)
  end

  def waitlist
    rated.offset(Setting.get.available_spots)
  end

  def accepted_for_invitation_without_expired
    rated_except_for_expired_and_confirmed.limit(Setting.get.available_spots)
  end

  def to_invite
    rated_except_for_expired_and_confirmed
    .limit(Setting.get.available_spots)
    .where('invitation_token IS ?', nil)
  end

  def to_remind
    rated_except_for_expired_and_confirmed
    .limit(Setting.get.available_spots)
    .where('invitation_token_created_at > ? AND invitation_token_created_at < ?',
      (Setting.get.days_to_confirm_invitation - 1).days.ago,
      (Setting.get.days_to_confirm_invitation - 2).days.ago)
  end

  def with_confirmed_invitation
    rated.where(invitation_confirmed: true)
  end

  def first(submissions)
    submissions.reorder('created_at ASC').first
  end

  def last(submissions)
    submissions.reorder('created_at DESC').first
  end

  def next(submissions, current_submission)
    submissions.where('submissions.created_at > ?', current_submission.created_at)
      .reorder('created_at ASC').first
  end

  def previous(submissions, current_submission)
    submissions.where('submissions.created_at < ?', current_submission.created_at)
      .reorder('created_at DESC').first
  end

  private

  def not_rejected
    Submission.where(rejected: false)
  end

  def with_rates_if_any
    not_rejected.joins("LEFT JOIN rates ON submissions.id = rates.submission_id").
      group('submissions.id')
  end

  def rated_except_for_expired_and_confirmed
    rated.where(
      'invitation_token IS ? OR invitation_confirmed = ? OR invitation_token_created_at > ?',
      nil, true, Setting.get.days_to_confirm_invitation.days.ago)
  end
end
