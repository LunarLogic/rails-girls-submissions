class MailingsController < ApplicationController
  def send_invitation_emails
    redirect_to :back, notice: "You have sent the emails."
  end
end
