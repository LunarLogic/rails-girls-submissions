class SubmissionsInviter
  def initialize(event_dates, event_venue, contact_email)
    @event_dates = event_dates
    @event_venue = event_venue
    @contact_email = contact_email
  end

  def call(submissions, deliver_now_or_later:)
    validate_deliver_now_or_later(deliver_now_or_later)

    if Setting.registration_period?
      result = Result.new(nil, false, "Registration is still open")
    elsif submissions.empty?
      result = Result.new(nil, false, "There are no emails to send.")
    else
      submissions.each { |submission| invite(submission, deliver_now_or_later) }
      message = case deliver_now_or_later
                when :now
                  "You have sent the emails."
                when :later
                  "The emails will be delivered shortly."
                end
      result = Result.new(nil, true, message)
    end

    result
  end

  private

  attr_reader :event_dates, :event_venue, :contact_email

  def validate_deliver_now_or_later(value)
    unless value.in?([:now, :later])
      raise ArgumentError, "deliver_now_or_later accepts :now or :later, but #{value.inspect} was given"
    end
  end

  def invite(submission, deliver_now_or_later)
    Submission.transaction do
      submission.generate_invitation_token!
      email = InvitationsMailer.invitation_email(submission, event_dates, event_venue, contact_email)

      case deliver_now_or_later
      when :now
        email.deliver_now
      when :later
        email.deliver_later
      end
    end
  end
end
