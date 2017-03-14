class InvitationsMailer < ApplicationMailer
  def invitation_email(submission, event_dates, event_venue)
    email = submission.email
    @token = submission.invitation_token
    @event_dates = event_dates
    @event_venue = event_venue
    mail(to: email, subject: 'Your application has been accepted!')
  end

  def reminder_email(submission, event_dates, event_venue)
    email = submission.email
    @token = submission.invitation_token
    @event_dates = event_dates
    @event_venue = event_venue
    mail(to: email, subject: 'Your invitation link expires tomorrow!')
  end
end
