source 'https://rubygems.org'
ruby '2.3.8'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '4.2.11.3'
gem 'rails', '5.1.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'devise'

gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'

gem 'whenever', require: false

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'pg'

gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'high_voltage', '~> 3.1'

group :production do
  gem 'unicorn'
end

group :development, :test do
  gem 'awesome_print'
  gem 'byebug', require: true
  gem 'pry-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'better_errors'
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'bcrypt_pbkdf', '~> 1.0'
  gem 'capistrano', '~> 3.3'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano3-unicorn'
  gem 'listen'
  gem 'rbnacl', '>= 3.2', '< 5.0'
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
end

group :test do
  gem 'capybara', '2.16.1', require: false
  gem 'capybara-screenshot'
  gem 'database_cleaner', require: false
  gem 'factory_bot_rails', '~> 4.0', require: false
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 4.0'
  gem 'selenium-webdriver', require: false
  gem 'timecop'
  gem 'webdrivers', '~> 3.0'
end
