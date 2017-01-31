class MailingsController < ApplicationController
  def send_invitation_emails
    submissions_to_invite = SubmissionRepository.new.to_invite

    submissions_to_invite.each do |submission|
      SubmissionsInviter.new.invite(submission)
    end

    redirect_to :back, notice: "You have sent the emails."
  end
end
