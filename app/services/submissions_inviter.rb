class SubmissionsInviter
  def invite(submission)
    submission.generate_confirmation_token!
    submission.awaiting!
    InvitationsMailer.invitation_email(submission).deliver_now
  end
end
