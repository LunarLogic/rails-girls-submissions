class SubmissionRepository
  def rejected
    Submission.where(rejected: true)
  end

  def valid
    Submission.where(rejected: false)
  end

  def to_rate
    to_rate_scope.to_a
  end

  def rated
    rated_scope.to_a
  end

  def accepted
    rated_scope.having('avg(value) >= ?', Setting.get.accepted_threshold).to_a
  end

  def waitlist
    rated_scope.having('avg(value) < ?', Setting.get.accepted_threshold).to_a
  end

  def next_to_rate(current_created_at)
    to_rate_scope.where('submissions.created_at > ?', current_created_at).order('created_at ASC')
      .first || to_rate_scope.first
  end

  def previous_to_rate(current_created_at)
    to_rate_scope.where('submissions.created_at < ?', current_created_at).order('created_at DESC')
      .first || to_rate_scope.last
  end

  def unaccepted
    with_rates_if_any.having('avg(value) < ?', Setting.get.accepted_threshold).to_a + rejected
  end

  private

  def to_rate_scope
    with_rates_if_any.having('count("rates") < ?', required_rates_number)
  end

  def rated_scope
    with_rates_if_any.having('count("rates") >= ?',  required_rates_number).order('AVG(value) DESC')
  end

  def with_rates_if_any
    Submission.where(rejected: false).joins("LEFT JOIN rates ON submissions.id = rates.submission_id").
      group('submissions.id')
  end

  def required_rates_number
    Setting.get.required_rates_num
  end
end
