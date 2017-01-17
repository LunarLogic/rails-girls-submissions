class WaitingSubmissionsAcceptor
  def call
    #TODO: Confirm if submissions first in waiting line come first
    waiting_submissions.each do |waiting_submission|
      expired_submission = not_rejected_expired_submission
      break unless expired_submission

      reject_expired_submission(expired_submission)

      send_email_with_confirmation_link(waiting_submission)
    end
  end

  private

  def waiting_submissions
    SubmissionRepository.new.waitlist.select { |w| w.confirmation_token.nil? }
  end

  def not_rejected_expired_submission
    Submission.all.select do |submission|
      expired_submission?(submission)
    end.first #TODO: Sort by confirmation_token_created_at?
  end

  def reject_expired_submission(expired_submission)
    expired_submission.reject
    expired_submission.save
  end

  def send_email_with_confirmation_link(waiting_submission)
    waiting_submission.generate_confirmation_token!
    ResultsMailer.accepted_email(waiting_submission).deliver_now
  end

  def expired_submission?(submission)
    submission.confirmation_token.present? && submission.confirmation_token_created_at < 1.week.ago && !submission.rejected && !submission.confirmed
  end
end
