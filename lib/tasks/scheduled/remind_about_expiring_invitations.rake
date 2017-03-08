namespace :scheduled do
  task remind_about_expiring_invitations: :environment do
    submissions = SubmissionRepository.new.to_remind
    InvitationsReminder.new.call(submissions)
  end
end
