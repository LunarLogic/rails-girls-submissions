namespace :scheduled do
  task waiting_list_emails: :environment do
    WaitingSubmissionsAcceptor.new.call
  end
end
