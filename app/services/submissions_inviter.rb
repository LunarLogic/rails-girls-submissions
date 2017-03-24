class SubmissionsInviter
  def initialize(event_dates, event_venue, contact_email)
    @event_dates = event_dates
    @event_venue = event_venue
    @contact_email = contact_email
  end

  def call(submissions)
    if !Setting.registration_period?
      false
    elsif submissions.empty?
      false
    else
      submissions.each { |submission| invite(submission) }
    end
  end

  private

  attr_reader :event_dates, :event_venue, :contact_email

  def invite(submission)
    submission.generate_invitation_token!
    InvitationsMailer.invitation_email(submission, event_dates, event_venue, contact_email).deliver_now
  end
end
