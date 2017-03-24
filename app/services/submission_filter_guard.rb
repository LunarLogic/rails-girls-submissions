class SubmissionFilterGuard
  FILTERS = [:valid, :rejected, :to_rate, :results, :participants]

  def initialize(submission, filter, submission_repository = SubmissionRepository.new)
    @submission = submission
    @filter = filter
    @submission_repository = submission_repository
  end

  def call
    if !FILTERS.include?(filter)
      result = Result.new(filter, false, [:forbidden_filter])
    elsif !submission_belongs_to_the_filter?
      result = Result.new(filter, false, [:incorrect_filter])
    else
      result = Result.new(filter, true, [])
    end

    result
  end

  private

  attr_reader :submission, :filter, :submission_repository

  def submission_belongs_to_the_filter?
    filtered_submissions = submission_repository.send(filter)
    filtered_submissions.include?(submission)
  end
end
