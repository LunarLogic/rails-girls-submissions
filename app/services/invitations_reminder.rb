class InvitationsReminder
  def initialize(event_dates, event_venue)
    @event_dates = event_dates
    @event_venue = event_venue
  end

  def call(submissions)
    return unless Setting.registration_period?
    
    submissions.each { |submission| remind_about_expiring_invitation(submission) }
  end

  private

  attr_reader :event_dates, :event_venue

  def remind_about_expiring_invitation(submission)
    InvitationsMailer.reminder_email(submission, event_dates, event_venue).deliver_now
  end
end
