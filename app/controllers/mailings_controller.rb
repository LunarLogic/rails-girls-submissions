class MailingsController < ApplicationController
  def send_invitation_emails
    setting = Setting.get
    submissions = SubmissionRepository.new.to_invite
    setting_presenter = SettingPresenter.new(setting)
    contact_email = Rails.application.secrets.mailchimp["contact_email"]
    if SubmissionsInviter.new(setting_presenter.event_dates, setting_presenter.event_venue, contact_email).call(submissions)
      setting.update_attributes(invitation_process_started: true)
      redirect_to :back, notice: "You have sent the emails."
    else
      redirect_to :back, notice: "There are no emails to send."
    end
  end
end
