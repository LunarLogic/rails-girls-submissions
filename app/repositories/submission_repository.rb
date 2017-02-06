class SubmissionRepository
  def rejected
    Submission.where(rejected: true).order('created_at ASC')
  end

  def valid
    not_rejected.order('created_at ASC')
  end

  def rated
    rated_scope.to_a
  end

  def to_rate
    to_rate_scope.to_a
  end

  def next(current_created_at)
    get_next_submission(current_created_at) || get_first_submission
  end

  def previous(current_created_at)
    get_previous_submission(current_created_at) || get_last_submission
  end

  def accepted
    rated_scope.limit(Setting.get.available_spots).to_a
  end

  def waitlist
    rated_scope.offset(Setting.get.available_spots).to_a
  end

  def to_invite
    accepted_for_invitation_without_expired.select { |s| !s.confirmation_token? }
  end
  private

  def accepted_for_invitation_without_expired
    rated_scope
      .where(
        'confirmation_token IS ? OR confirmation_token_created_at > ? OR invitation_confirmed = ?',
        nil, 1.week.ago, true)
      .limit(Setting.get.available_spots)
  end

  def not_rejected
    Submission.where(rejected: false)
  end

  def get_next_submission(current_created_at)
    not_rejected.where('submissions.created_at > ?', current_created_at).order('created_at ASC').first
  end

  def get_previous_submission(current_created_at)
    not_rejected.where('submissions.created_at < ?', current_created_at).order('created_at DESC').first
  end

  def get_first_submission
    not_rejected.order('created_at ASC').first
  end

  def get_last_submission
    not_rejected.order('created_at DESC').first
  end

  def rated_scope
    with_rates_if_any.having('count("rates") >= ?',  required_rates_number).order('AVG(value) DESC')
  end

  def to_rate_scope
    with_rates_if_any.having('count("rates") < ?', required_rates_number).order('created_at DESC')
  end

  def with_rates_if_any
    not_rejected.joins("LEFT JOIN rates ON submissions.id = rates.submission_id").
      group('submissions.id')
  end

  def required_rates_number
    Setting.get.required_rates_num
  end
end
