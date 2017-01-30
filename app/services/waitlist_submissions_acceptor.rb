class WaitlistSubmissionsAcceptor
  def self.build
    new(SubmissionRepository.new, SubmissionsInviter.new)
  end

  def initialize(submission_repository, submissions_inviter)
    @submission_repository = submission_repository
    @submissions_inviter = submissions_inviter
  end

  def call
    submissions_to_be_expired.each do |s|
      s.expired!
    end

    waitlist_submissions.each do |s|
      invite_submission(s)
    end
  end

  private

  def waitlist_submissions
    @submission_repository.to_invite
  end

  def submissions_to_be_expired
    Submission.select do |submission|
      submission.has_expired?
    end
  end

  def invite_submission(waitlist_submission)
    @submissions_inviter.invite(waitlist_submission)
  end
end
