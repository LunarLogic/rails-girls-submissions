class SubmissionsInviter
  def invite(submission)
    submission.generate_confirmation_token!
    submission.awaiting!
    ResultsMailer.accepted_email(submission).deliver_now
  end
end
