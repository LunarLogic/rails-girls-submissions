class InvitationsMailer < ApplicationMailer
  def invitation_email(submission, event_dates, event_venue, contact_email)
    email = submission.email
    @token = submission.invitation_token
    @event_dates = event_dates
    @event_venue = event_venue
    @days_to_confirm = Setting.get.days_to_confirm_invitation
    @contact_email = contact_email
    mail(to: email, subject: 'Your application has been accepted!')
  end

  def reminder_email(submission, event_dates, event_venue, contact_email)
    email = submission.email
    @token = submission.invitation_token
    @event_dates = event_dates
    @event_venue = event_venue
    @contact_email = contact_email
    mail(to: email, subject: 'Your invitation link expires tomorrow!')
  end
end
