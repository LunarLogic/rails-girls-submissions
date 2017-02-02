namespace :scheduled do
  task handle_submissions_expiration: :environment do
    SubmissionsExpirationHandler.new.call
  end
end
