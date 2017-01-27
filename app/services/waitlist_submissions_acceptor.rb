class WaitlistSubmissionsAcceptor
  def self.build
    new(SubmissionRepository.new)
  end

  def initialize(submission_repository)
    @submission_repository = submission_repository
  end

  def call
    submissions_to_be_expired.each_with_index do |s, i|
      s.expired!
      send_email_with_confirmation_link(waitlist_submissions[i]) if waitlist_submissions[i]
    end
  end

  private

  def waitlist_submissions
    @waitlist_submissions ||= @submission_repository.waitlist.select { |w| w.confirmation_status.nil? }.flatten
  end

  def submissions_to_be_expired
    Submission.select do |submission|
      submission.has_expired?
    end
  end

  def send_email_with_confirmation_link(waitlist_submission)
    waitlist_submission.generate_confirmation_token!
    waitlist_submission.awaiting!
    ResultsMailer.accepted_email(waitlist_submission).deliver_now
  end
end
