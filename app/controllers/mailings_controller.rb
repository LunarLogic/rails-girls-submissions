class MailingsController < ApplicationController
  def send_invitation_emails
    if SubmissionsInviter.build.call
      redirect_to :back, notice: "You have sent the emails."
    else
      redirect_to :back, notice: "There are no emails to send."
    end
  end
end
