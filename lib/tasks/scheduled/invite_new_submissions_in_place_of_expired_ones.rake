namespace :scheduled do
  task invite_new_submissions_in_place_of_expired_ones: :environment do
    setting = Setting.get
    unless setting.invitation_process_started
      logger.info("skipping as invitation process is not in progress")
      next
    end

    logger.info("invite_new_submissions_in_place_of_expired_ones started")
    submissions = SubmissionRepository.new.to_invite
    setting_presenter = SettingPresenter.new(setting)
    contact_email = setting.contact_email
    SubmissionsInviter.new(setting_presenter.event_dates, setting_presenter.event_venue, contact_email)
      .call(submissions, deliver_now_or_later: :now)
    logger.info("invite_new_submissions_in_place_of_expired_ones finished")
  end

  def logger
    Logger.new(STDOUT)
  end
end
