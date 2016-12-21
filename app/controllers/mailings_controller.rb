class MailingsController < ApplicationController
  def send_emails
    submissions_accepted = SubmissionRepository.new.accepted
    # submissions_waitlist = SubmissionRepository.new.waitlist
    # submissions_unaccepted = SubmissionRepository.new.unaccepted

    submissions_accepted.each do |submission|
      ResultsMailer.accepted_email(submission).deliver_now
    end

    redirect_to :back, notice: "You have sent the emails."
  end
end
