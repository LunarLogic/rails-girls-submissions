class SubmissionPresenter < SimpleDelegator
  def initialize(submission, rates)
    super(submission)
    @rates = rates
  end

  def average_rate
    submission = __getobj__
    submission.average_rate.round(2) if submission.rated?
  end

  def rates_count
    @rates.count
  end

  def created_at
    submission = __getobj__
    submission.created_at.strftime("%m-%d-%Y")
  end
end
