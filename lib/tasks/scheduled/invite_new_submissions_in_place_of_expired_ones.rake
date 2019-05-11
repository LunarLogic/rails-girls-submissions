namespace :scheduled do
  task invite_new_submissions_in_place_of_expired_ones: :environment do
    setting = Setting.get
    unless setting.invitation_process_started
      logger.info("skipping as invitation process is not in progress")
      next
    end

    logger.info("invite_new_submissions_in_place_of_expired_ones started")
    submissions_to_invite, submissions_to_send_bad_news = SubmissionRepository.new.to_invite_and_to_send_bad_news
    setting_presenter = SettingPresenter.new(setting)
    contact_email = setting.contact_email
    available_spots = setting.available_spots
    result = SubmissionsInviter.new(
      setting_presenter.event_dates, setting_presenter.event_venue, contact_email, available_spots
    ).call(
      to_invite: submissions_to_invite,
      to_send_bad_news: submissions_to_send_bad_news,
      deliver_now_or_later: :now,
    )
    logger.info(
      "invite_new_submissions_in_place_of_expired_ones finished with #{result.success ? 'success' : 'failure'}: #{result.message}"
    )
  end

  def logger
    Logger.new(STDOUT)
  end
end
