namespace :scheduled do
  task waitlist_emails: :environment do
    WaitlistSubmissionsAcceptor.build.call
  end
end
