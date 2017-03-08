class MailingsController < ApplicationController
  def send_invitation_emails
    submissions = SubmissionRepository.new.to_invite
    if SubmissionsInviter.new.call(submissions)
      redirect_to :back, notice: "You have sent the emails."
    else
      redirect_to :back, notice: "There are no emails to send."
    end
  end
end
