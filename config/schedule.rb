# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "log/cron.log"

set :environment, ENV['RAILS_ENV'] || 'production'

every :day, at: '6:00 am' do
  rake 'scheduled:remind_about_expiring_invitations'
  rake 'scheduled:invite_new_submissions_in_place_of_expired_ones'
end
