class MailingsController < ApplicationController
  def send_invitation_emails
    setting = Setting.get
    submissions = SubmissionRepository.new.to_invite
    setting_presenter = SettingPresenter.new(setting)
    contact_email = Rails.application.secrets.mailchimp["contact_email"]
    result = SubmissionsInviter.new(setting_presenter.event_dates, setting_presenter.event_venue,
      contact_email).call(submissions, deliver_now_or_later: :later)

    if result.success
      setting.update_attributes(invitation_process_started: true)
      notice = "#{result.message} Go to Menu &rarr; Background Jobs to check if all emails got delivered successfully."
    else
      notice = result.message
    end

    redirect_to :back, notice: notice
  end
end
