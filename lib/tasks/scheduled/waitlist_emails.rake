namespace :scheduled do
  task waitlist_emails: :environment do
    WaitingSubmissionsAcceptor.build.call
  end
end
