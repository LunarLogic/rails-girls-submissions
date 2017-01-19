class SubmissionPresenter < SimpleDelegator
  def initialize(submission, rates, submission_repository)
    super(submission)
    @rates = rates
    @submission_repository = submission_repository
  end

  def average_rate
    if rated?
      average = @rates.count == 0 ? 0 : (@rates.sum(:value).to_f / @rates.count)
      average.round(2)
    end
  end

  def rates_count
    @rates.count
  end

  def created_at
    submission.created_at.strftime("%m-%d-%Y")
  end

  def next
    @submission_repository.next(submission.created_at)
  end

  def previous
    @submission_repository.previous(submission.created_at)
  end

  private

  def submission
    __getobj__
  end
end
