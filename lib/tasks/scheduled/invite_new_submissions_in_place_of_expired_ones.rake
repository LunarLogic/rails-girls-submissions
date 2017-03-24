namespace :scheduled do
  task invite_new_submissions_in_place_of_expired_ones: :environment do
    setting = Setting.get
    return unless setting.invitation_process_started

    logger.info("invite_new_submissions_in_place_of_expired_ones started")
    submissions = SubmissionRepository.new.to_invite
    setting_presenter = SettingPresenter.new(setting)
    contact_email = Rails.application.secrets.mailchimp["contact_email"]
    SubmissionsInviter.new(setting_presenter.event_dates, setting_presenter.event_venue, contact_email).call(submissions)
    logger.info("invite_new_submissions_in_place_of_expired_ones finished")
  end

  def logger
    Logger.new(STDOUT)
  end
end
