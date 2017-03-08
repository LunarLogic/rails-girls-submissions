namespace :scheduled do
  task invite_new_submissions_in_place_of_expired_ones: :environment do
    submissions = SubmissionRepository.new.to_invite
    SubmissionsInviter.new.call(submissions)
  end
end
