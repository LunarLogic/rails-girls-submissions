class SubmissionsInviter
  def call(submissions)
    if submissions.empty?
      false
    else
      submissions.each { |submission| invite(submission) }
    end
  end

  private

  def invite(submission)
    submission.generate_invitation_token!
    InvitationsMailer.invitation_email(submission).deliver_now
  end
end
