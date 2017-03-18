namespace :scheduled do
  task invite_new_submissions_in_place_of_expired_ones: :environment do
    logger.info("invite_new_submissions_in_place_of_expired_ones started")
    submissions = SubmissionRepository.new.to_invite
    setting = SettingPresenter.new(Setting.get)
    SubmissionsInviter.new(setting.event_dates, setting.event_venue).call(submissions)
    logger.info("invite_new_submissions_in_place_of_expired_ones finished")
  end

  def logger
    Logger.new(STDOUT)
  end
end
