class InvitationsMailer < ApplicationMailer
  def invitation_email#(submission, event_dates, event_venue, contact_email)
    email = 'slimakania@gmail.com' # submission.email
    @token = 'fake_token' # submission.invitation_token
    @event_dates = DateTime.now # event_dates
    @event_venue = 'Zendesk' # event_venue
    @days_to_confirm = 14 # Setting.get.days_to_confirm_invitation
    @contact_email = 'contact@railsgirlskrakow.pl' # contact_email

    mail(to: email, reply_to: contact_email, subject: 'Confirm your Rails Girls Kraków 2022 participation!')
  end

  def reminder_email(submission, event_dates, event_venue, contact_email)
    email = submission.email
    @token = submission.invitation_token
    @event_dates = event_dates
    @event_venue = event_venue
    @contact_email = contact_email

    mail(to: email, reply_to: contact_email, subject: 'Your invitation link expires soon!')
  end

  def bad_news_email(submission, available_spots, contact_email)
    email = submission.email
    @available_spots = available_spots
    @contact_email = contact_email

    mail(to: email, reply_to: contact_email, subject: 'Your application for Rails Girls Kraków 2022')
  end
end
