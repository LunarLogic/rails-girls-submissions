class SubmissionsInviter
  def initialize(event_dates, event_venue, contact_email)
    @event_dates = event_dates
    @event_venue = event_venue
    @contact_email = contact_email
  end

  def call(submissions)
    if Setting.registration_period?
      result = Result.new(nil, false, "Registration is still open")
    elsif submissions.empty?
      result = Result.new(nil, false, "There are no emails to send.")
    else
      submissions.each { |submission| invite(submission) }
      result = Result.new(nil, true, "You have sent the emails.")
    end

    result
  end

  private

  attr_reader :event_dates, :event_venue, :contact_email

  def invite(submission)
    Submission.transaction do
      submission.generate_invitation_token!
      InvitationsMailer.invitation_email(submission, event_dates, event_venue, contact_email).deliver_now
    end
  end
end
