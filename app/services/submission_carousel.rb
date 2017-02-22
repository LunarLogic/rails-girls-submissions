class SubmissionCarousel
  FILTERS = [:valid, :rejected, :to_rate, :accepted, :waitlist, :with_confirmed_invitation]

  def self.build(filter)
    raise ArgumentError unless FILTERS.include?(filter)
    submission_repository = SubmissionRepository.new

    new(submission_repository, submission_repository.send(filter))
  end

  def initialize(submission_repository, submissions)
    @submission_repository = submission_repository
    @submissions = submissions
  end

  def next(current_submission)
    submission_repository.next(submissions, current_submission) || submission_repository.first(submissions)
  end

  def previous(current_submission)
    submission_repository.previous(submissions, current_submission) || submission_repository.last(submissions)
  end

  private

  attr_reader :submission_repository, :submissions
end
