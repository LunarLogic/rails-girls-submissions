class ResultsMailer < ApplicationMailer
  def accepted_email(submission)
    email = submission.email
    @token = submission.confirmation_token
    mail(to: email, subject: 'Your application has been accepted!')
  end

  def rejected_email(submission)
    # @email = submission.email
  end

  def waitlist_email(submission)
    # @email = submission.email
  end
end
