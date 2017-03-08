namespace :scheduled do
  task remind_about_expiring_invitations: :environment do
    InvitationsReminder.build.call
  end
end
