class SubmissionPresenter < SimpleDelegator
  def initialize(submission, rates)
    super(submission)
    @rates = rates
  end

  def average_rate
    submission = __getobj__

    if submission.rated?
      average = @rates.count == 0 ? 0 : (@rates.sum(:value).to_f / @rates.count)
      average.round(2)
    end
  end

  def rates_count
    @rates.count
  end

  def created_at
    submission = __getobj__
    submission.created_at.strftime("%m-%d-%Y")
  end
end
