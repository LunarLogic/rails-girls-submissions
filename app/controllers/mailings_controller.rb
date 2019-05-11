class MailingsController < ApplicationController
  def send_invitation_emails
    setting = Setting.get
    submissions_to_invite, submissions_to_send_bad_news = SubmissionRepository.new.to_invite_and_to_send_bad_news
    setting_presenter = SettingPresenter.new(setting)
    contact_email = setting.contact_email
    available_spots = setting.available_spots
    result = SubmissionsInviter.new(
      setting_presenter.event_dates, setting_presenter.event_venue, contact_email, available_spots
    ).call(
      to_invite: submissions_to_invite,
      to_send_bad_news: submissions_to_send_bad_news,
      deliver_now_or_later: :later,
    )

    if result.success
      setting.update_attributes(invitation_process_started: true)
      notice = "#{result.message} Go to Menu &rarr; Background Jobs to check if all emails got delivered successfully."
    else
      notice = result.message
    end

    redirect_to :back, notice: notice
  end
end
