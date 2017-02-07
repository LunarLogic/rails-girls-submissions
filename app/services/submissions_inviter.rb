class SubmissionsInviter
  def initialize(submission_repository: SubmissionRepository.new)
    @submission_repository = submission_repository
  end

  def call
    submissions_to_invite.each do |submission|
      invite(submission)
    end
  end

  private
  attr_reader :submission_repository

  def submissions_to_invite
    submission_repository.accepted_for_invitation_without_expired.select { |s| !s.invitation_token? }
  end

  def invite(submission)
    submission.generate_invitation_token!
    InvitationsMailer.invitation_email(submission).deliver_now
  end
end
