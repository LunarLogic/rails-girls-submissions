class SubmissionsInviter
  def initialize(event_dates, event_venue, contact_email, available_spots)
    @event_dates = event_dates
    @event_venue = event_venue
    @contact_email = contact_email
    @available_spots = available_spots
  end

  def call(to_invite:, to_send_bad_news:, deliver_now_or_later:)
    validate_deliver_now_or_later(deliver_now_or_later)

    all_submissions = to_invite + to_send_bad_news

    if Setting.registration_period?
      return Result.new(nil, false, "Registration is still open")
    end

    if all_submissions.empty?
      return Result.new(nil, false, "There are no emails to send.")
    end

    to_invite.each { |submission| invite(submission, deliver_now_or_later) }
    to_send_bad_news.each { |submission| send_bad_news(submission, deliver_now_or_later) }

    message = case deliver_now_or_later
              when :now
                "You have sent the emails."
              when :later
                "The emails will be delivered shortly."
              end

    Result.new(nil, true, message)
  end

  private

  attr_reader :event_dates, :event_venue, :contact_email, :available_spots

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

  def send_bad_news(submission, deliver_now_or_later)
    Submission.transaction do
      submission.mark_bad_news_delivery!
      email = InvitationsMailer.bad_news_email(submission, available_spots, contact_email)

      case deliver_now_or_later
      when :now
        email.deliver_now
      when :later
        email.deliver_later
      end
    end
  end
end
