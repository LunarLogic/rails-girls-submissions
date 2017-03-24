class SubmissionsInviter
  def initialize(event_dates, event_venue, contact_email, logger = Logger.new(STDOUT))
    @event_dates = event_dates
    @event_venue = event_venue
    @contact_email = contact_email
    @logger = logger
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
