namespace :scheduled do
  task invite_new_submissions_in_place_of_expired_ones: :environment do
    SubmissionsInviter.build.call
  end
end
