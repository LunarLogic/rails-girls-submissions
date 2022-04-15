class SubmissionFilterGuard
  FILTERS = [:valid, :rejected, :to_rate, :results, :participants].freeze

  def initialize(submission, filter, submission_repository = SubmissionRepository.new)
    @submission = submission
    @filter = filter
    @submission_repository = submission_repository
  end

  def call
    result = if !FILTERS.include?(filter)
               Result.new(filter, false, :forbidden_filter)
             elsif !submission_belongs_to_the_filter? && !back_from_rating?
               Result.new(filter, false, :incorrect_filter)
             else
               Result.new(filter, true, nil)
             end

    result
  end

  private

  attr_reader :submission, :filter, :submission_repository

  def submission_belongs_to_the_filter?
    filtered_submissions = submission_repository.send(filter)
    filtered_submissions.include?(submission)
  end

  def back_from_rating?
    submission.status == :rated
  end
end
