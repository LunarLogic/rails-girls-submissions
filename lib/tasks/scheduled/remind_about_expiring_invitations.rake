namespace :scheduled do
  task remind_about_expiring_invitations: :environment do
    logger.info("remind_about_expiring_invitations started")
    submissions = SubmissionRepository.new.to_remind
    setting = SettingPresenter.new(Setting.get)
    InvitationsReminder.new(setting.event_dates, setting.event_venue).call(submissions)
    logger.info("remind_about_expiring_invitations finished")
  end

  def logger
    Logger.new(STDOUT)
  end
end
