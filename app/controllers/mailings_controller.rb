class MailingsController < ApplicationController
  def send_invitation_emails
    SubmissionsInviter.new.call

    redirect_to :back, notice: "You have sent the emails."
  end
end
