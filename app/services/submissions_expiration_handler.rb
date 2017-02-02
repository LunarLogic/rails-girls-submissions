class SubmissionsExpirationHandler
  def initialize(submissions_inviter: SubmissionsInviter.new)
    @submissions_inviter = submissions_inviter
  end

  def call
    submissions_to_be_expired.each do |s|
      s.expired!
    end

    invite_submissions
  end

  private
  attr_reader :submissions_inviter

  def submissions_to_be_expired
    Submission.select do |submission|
      submission.past_confirmation_due_date?
    end
  end

  def invite_submissions
    submissions_inviter.call
  end
end
