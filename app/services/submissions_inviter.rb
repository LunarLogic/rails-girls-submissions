class SubmissionsInviter
  def self.build
    new(SubmissionRepository.new.to_invite)
  end

  def initialize(submissions)
    @submissions = submissions
  end

  def call
    submissions.each { |submission| invite(submission) }
  end

  private
  attr_reader :submissions

  def invite(submission)
    submission.generate_invitation_token!
    InvitationsMailer.invitation_email(submission).deliver_now
  end
end
