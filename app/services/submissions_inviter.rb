class SubmissionsInviter
  def initialize(submission_repository: SubmissionRepository.new)
    @submission_repository = submission_repository
  end

  def call
    submission_repository.to_invite.each do |submission|
      invite(submission)
    end
  end

  private
  attr_reader :submission_repository

  def invite(submission)
    submission.generate_confirmation_token!
    submission.awaiting!
    InvitationsMailer.invitation_email(submission).deliver_now
  end
end
