class SubmissionsInviter
  def initialize(event_dates, event_venue, contact_email, logger = Logger.new(STDOUT))
    @event_dates = event_dates
    @event_venue = event_venue
    @contact_email = contact_email
    @logger = logger
  end

  def call(submissions)
    if !Setting.registration_period?
      result = Result.new(nil, false, "Registration is closed")
    elsif submissions.empty?
      result = Result.new(nil, false, "There are no emails to send.")
    else
      submissions.each { |submission| invite(submission) }
      result = Result.new(nil, true, "You have sent the emails.")
    end

    result
  end

  private

  attr_reader :event_dates, :event_venue, :contact_email, :logger

  def invite(submission)
    begin
      submission.generate_invitation_token!
      InvitationsMailer.invitation_email(submission, event_dates, event_venue, contact_email).deliver_now
    rescue => e
      logger.error(e)
      submission.update_attributes(invitation_token: nil, invitation_token_created_at: nil)
    end
  end
end
