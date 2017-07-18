# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

require 'capistrano/rbenv'
require "capistrano3/unicorn"
require "capistrano/bundler"
require "capistrano/rails"
require "whenever/capistrano"
# require "honeybadger/capistrano"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
