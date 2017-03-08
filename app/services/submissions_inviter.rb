class SubmissionsInviter
  def self.build
    new(SubmissionRepository.new.to_invite)
  end

  def initialize(submissions)
    @submissions = submissions
  end

  def call
    if submissions
      submissions.each { |submission| invite(submission) }
      true
    else
      false
    end
  end

  private
  attr_reader :submissions

  def invite(submission)
    submission.generate_invitation_token!
    InvitationsMailer.invitation_email(submission).deliver_now
  end
end
