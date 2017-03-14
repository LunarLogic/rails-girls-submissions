namespace :scheduled do
  task invite_new_submissions_in_place_of_expired_ones: :environment do
    submissions = SubmissionRepository.new.to_invite
    setting = SettingPresenter(Setting.get)
    SubmissionsInviter.new(setting.event_dates, setting.event_venue).call(submissions)
  end
end
