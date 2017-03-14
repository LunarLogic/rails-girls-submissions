class MailingsController < ApplicationController
  def send_invitation_emails
    submissions = SubmissionRepository.new.to_invite
    setting = SettingPresenter.new(Setting.get)
    if SubmissionsInviter.new(setting.event_dates, setting.event_venue).call(submissions)
      redirect_to :back, notice: "You have sent the emails."
    else
      redirect_to :back, notice: "There are no emails to send."
    end
  end
end
