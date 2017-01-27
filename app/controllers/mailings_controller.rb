class MailingsController < ApplicationController
  def send_emails
    submissions_accepted = SubmissionRepository.new.accepted

    submissions_accepted.each do |submission|
      submission.generate_confirmation_token!
      submission.awaiting!
      ResultsMailer.accepted_email(submission).deliver_now
    end

    redirect_to :back, notice: "You have sent the emails."
  end
end
