namespace :scheduled do
  task remind_about_expiring_invitations: :environment do
    InvitationsReminder.new.call
  end
end
