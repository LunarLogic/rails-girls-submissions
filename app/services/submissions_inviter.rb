class SubmissionsInviter
  def initialize(event_dates, event_venue)
    @event_dates = event_dates
    @event_venue = event_venue
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

  attr_reader :event_dates, :event_venue

  def invite(submission)
    submission.generate_invitation_token!
    InvitationsMailer.invitation_email(submission, event_dates, event_venue).deliver_now
  end
end
