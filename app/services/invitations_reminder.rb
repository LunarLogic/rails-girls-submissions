class InvitationsReminder
  def initialize(event_dates, event_venue, contact_email)
    @event_dates = event_dates
    @event_venue = event_venue
    @contact_email = contact_email
  end

  def call(submissions)
    return unless Setting.registration_period?
    
    submissions.each { |submission| remind_about_expiring_invitation(submission) }
  end

  private

  attr_reader :event_dates, :event_venue, :contact_email

  def remind_about_expiring_invitation(submission)
    InvitationsMailer.reminder_email(submission, event_dates, event_venue, contact_email).deliver_now
  end
end
