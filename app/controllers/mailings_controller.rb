class MailingsController < ApplicationController
  def send_emails
    submissions_accepted = SubmissionRepository.new.to_invite

    submissions_accepted.each do |submission|
      SubmissionsInviter.new.invite(submission)
    end

    redirect_to :back, notice: "You have sent the emails."
  end
end
