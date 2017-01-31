namespace :scheduled do
  task handle_submissions_expiration: :environment do
    SubmissionsExpirationHandler.build.call
  end
end
