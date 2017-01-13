namespace :scheduled do
  task waiting_list_emails: :environment do
    waiting_submissions = SubmissionRepository.new.waitlist.select { |w| w.confirmation_token.nil? }

    #TODO: Confirm if submissions first in waiting line come first
    waiting_submissions.each do |waiting_submission|
      expired_submission = Submission.all.select do |s|
        s.confirmation_token.present? && s.confirmation_token_created_at < 1.week.ago && !s.rejected
      end.first #TODO: Sort by confirmation_token_created_at?

      break unless expired_submission

      expired_submission.reject
      expired_submission.save

      waiting_submission.generate_confirmation_token!
      ResultsMailer.accepted_email(waiting_submission).deliver_now
    end
  end
end
