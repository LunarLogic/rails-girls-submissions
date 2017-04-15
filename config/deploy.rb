# Add following gems to your Gemfile:
#
# group :development do
#  gem "capistrano", "~> 3.3"
#  gem "capistrano-rvm"
#  gem "capistrano-bundler"
#  gem "capistrano-rails"
#  gem "capistrano3-unicorn"
# end
#
# Update Capfile
# require "capistrano/rvm"
# require "capistrano3/unicorn"
# require "capistrano/bundler"
# require "capistrano/rails"
# require "honeybadger/capistrano"

set :application, "railsgirls"
set :branch, "master"

set :repo_url, "https://github.com/LunarLogic/rails-girls-submissions.git"
set :deploy_via, :remote_cache
set :copy_exclude, [".git"]

set :user, "lunar"
set :deploy_to, -> { "/home/#{fetch(:user)}/apps/#{fetch(:application)}" }

set :unicorn_rack_env, -> { fetch(:rails_env) }
set :unicorn_config_path, -> { File.join(release_path, "config/unicorn.rb") }
set :unicorn_pid, -> { File.join(current_path, "pids/unicorn.pid") }

set :rails_env, "production"
set :rack_env, -> { fetch(:rails_env) }
set :deploy_env, -> { fetch(:rails_env) }
set :honeybadger_env, -> { fetch(:stage) }
fetch(:default_env).merge!(rails_env: "production", rack_env: "production")
set :ssh_options, { forward_agent: true }

set :rvm_type, :system
set :rvm_ruby_version, -> { "2.3.0@#{fetch(:application)}" }
set :bundle_path, -> { File.join(fetch(:rvm_path), "gems/ruby-#{fetch(:rvm_ruby_version)}") }
set :bundle_cmd, -> { File.join(fetch(:bundle_path), "bin/bundle") }

set :bundle_binstubs, -> { File.join(fetch(:bundle_path), "bin") }

set :keep_releases, 5

set :linked_files, %w{config/database.yml config/unicorn.rb config/secrets.yml config/allowed_users.yml}
set :linked_dirs, %w{pids log public/assets}

# Namespace the crontab entries by application and stage
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

after "deploy:publishing", "unicorn:stop", "unicorn:start"
after "deploy:finishing",  "deploy:cleanup"

# Sidekiq with god. See more info here:
# https://sites.google.com/a/lunarlogic.io/wiki/development-resources-services/monitoring-sidekiq-with-god

# Uncomment if you want to use god
#namespace :god do
  #desc "Restarts god"
  #task :restart do
    #on roles(:app) do
      #execute "/etc/init.d/god restart"
    #end
  #end
#end
#after "deploy:finished", "god:restart"

# Uncomment if you want to use sidekiq
#namespace :sidekiq do
  #desc "Restarts sidekiq"
  #task :restart do
    #on roles(:app) do
      #execute "/usr/local/bin/god restart sidekiq"
    #end
  #end
#end
#after "deploy:god_restart", "sidekiq:restart"
