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
      .order('submissions.created_at ASC')
  end

  def rated
    with_rates_if_any
      .having('count("rates") >= ?', Setting.get.required_rates_num)
      .order('AVG(value) DESC')
  end

  def results
    rated
  end

  def to_invite_and_to_send_bad_news
    to_invite = rated_not_invited.limit(limit_to_invite_at_the_moment)
    to_send_bad_news = didnt_receive_bad_news_nor_invitation.where.not(id: to_invite.ids)

    [to_invite, to_send_bad_news]
  end

  def to_remind
    expiring_in_two_days
  end

  def participants
    with_rates_if_any.where(invitation_confirmed: true).order('AVG(value) DESC')
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

  def comments(submission)
    submission.comments.order(:updated_at)
  end

  def rates(submission)
    submission.rates.order(:updated_at)
  end

  private

  def not_rejected
    Submission.where(rejected: false)
  end

  def didnt_receive_bad_news_nor_invitation
    Submission.where(invitation_token: nil, bad_news_sent_at: nil)
  end

  def with_rates_if_any
    not_rejected.joins("LEFT JOIN rates ON submissions.id = rates.submission_id").
      group('submissions.id')
  end

  def rated_not_invited
    rated.where('invitation_token IS ?', nil)
  end

  def limit_to_invite_at_the_moment
    limit = Setting.get.available_spots - confirmed_or_still_able_to_confirm_spots
    limit >= 0 ? limit : 0
  end

  def confirmed_or_still_able_to_confirm_spots
    confirmed.length + invited_not_expired_not_confirmed.length
  end

  def confirmed
    Submission.where('invitation_confirmed = ?', true)
  end

  def invited_not_expired
    with_rates_if_any
      .where('invitation_token IS NOT ? AND DATE(invitation_token_created_at) > ?',
    nil, Setting.get.days_to_confirm_invitation.days.ago.to_date)
      .order('AVG(value) DESC')
  end

  def invited_not_expired_not_confirmed
    invited_not_expired.where('invitation_confirmed = ?', false)
  end

  def expiring_in_two_days
    days_to_confirm_invitation = Setting.get.days_to_confirm_invitation

    from = (days_to_confirm_invitation - 1).days.ago.to_date
    to = (days_to_confirm_invitation - 2).days.ago.to_date
    invited_not_expired_not_confirmed.where(
      'DATE(invitation_token_created_at) > ? AND DATE(invitation_token_created_at) <= ?',
      from, to)
  end
end
