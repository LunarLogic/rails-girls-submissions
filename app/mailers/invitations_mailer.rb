class InvitationsMailer < ApplicationMailer
  def invitation_email(submission, event_dates, event_venue, contact_email)
    email = submission.email
    @token = submission.invitation_token
    @event_dates = event_dates
    @event_venue = event_venue
    @days_to_confirm = Setting.get.days_to_confirm_invitation
    mail(to: email, subject: 'Confirm your Rails Girls Kraków 2017 participation!')
    @contact_email = contact_email
  end

  def reminder_email(submission, event_dates, event_venue, contact_email)
    email = submission.email
    @token = submission.invitation_token
    @event_dates = event_dates
    @event_venue = event_venue
    mail(to: email, subject: 'Your invitation link expires soon!')
    @contact_email = contact_email
  end
end
