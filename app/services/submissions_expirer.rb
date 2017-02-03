class SubmissionsExpirer
  def initialize(submission_repository: SubmissionRepository.new)
    @submission_repository = submission_repository
  end

  def call
    submission_repository.to_expire.each{ |s| s.expired! }
  end

  private
  attr_reader :submission_repository
end
