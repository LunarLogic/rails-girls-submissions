class SubmissionRepository
  def rejected
    Submission.where(rejected: true)
  end

  def rated
    rated_scope.to_a
  end

  def to_rate
    to_rate_scope.to_a
  end

  def next(current_created_at)
    not_rejected.where('submissions.created_at > ?', current_created_at).order('created_at ASC')
      .first || not_rejected.first
  end

  def previous(current_created_at)
    not_rejected.where('submissions.created_at < ?', current_created_at).order('created_at DESC')
      .first || not_rejected.last
  end

  def accepted
    with_rates_if_any.having('count("rates") >= ? AND avg(value) >= ?', Setting.get.required_rates_num,
      Setting.get.accepted_threshold).to_a
  end

  def waitlist
    with_rates_if_any.having('count("rates") >= ? AND avg(value) < ? AND avg(value) >= ?',
      Setting.get.required_rates_num, Setting.get.accepted_threshold, Setting.get.waitlist_threshold).to_a
  end

  def unaccepted
    with_rates_if_any.having('avg(value) < ?', Setting.get.waitlist_threshold).to_a + rejected
  end

  private

  def rated_scope
    with_rates_if_any.having('count("rates") >= ?',  required_rates_number)
  end

  def to_rate_scope
    with_rates_if_any.having('count("rates") < ?', required_rates_number)
  end

  def with_rates_if_any
    not_rejected.joins("LEFT JOIN rates ON submissions.id = rates.submission_id").
      group('submissions.id')
  end

  def not_rejected
    Submission.where(rejected: false)
  end

  def required_rates_number
    Setting.get.required_rates_num
  end
end
