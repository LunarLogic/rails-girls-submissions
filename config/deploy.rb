set :application, "rails-girls-submissions"
set :branch, "master"

set :repo_url, "https://github.com/LunarLogic/rails-girls-submissions.git"
set :deploy_via, :remote_cache
set :copy_exclude, [".git"]

set :user, "lunar"
set :deploy_to, "/home/#{fetch(:user)}/application/"

set :unicorn_rack_env, -> { fetch(:rails_env) }
set :unicorn_config_path, -> { File.join(release_path, "config/unicorn.rb") }
set :unicorn_pid, -> { File.join(current_path, "pids/unicorn.pid") }

set :rails_env, "production"
set :rack_env, -> { fetch(:rails_env) }
set :deploy_env, -> { fetch(:rails_env) }
set :honeybadger_env, -> { fetch(:stage) }
fetch(:default_env).merge!(rails_env: "production", rack_env: "production")
set :ssh_options, { forward_agent: true }

set :rbenv_type, :system
set :rbenv_ruby, '2.3.0'

set :keep_releases, 5

set :linked_files, %w{config/database.yml config/secrets.yml config/allowed_users.yml}
set :linked_dirs, %w{tmp/pids log public/assets tmp/sockets}

# Namespace the crontab entries by application and stage
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do
  task :restart do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute "sudo systemctl restart #{fetch(:application)}"
    end
  end
end

after 'deploy:publishing', 'deploy:restart'
after "deploy:finishing",  "deploy:cleanup"

