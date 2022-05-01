require File.expand_path('boot', __dir__)

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsGirlsSubmissions
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Warsaw'
    config.active_record.default_timezone = :local

    config.autoload_paths << Rails.root.join('app/presenters')
    config.autoload_paths << Rails.root.join('app/repositories')

    config.action_view.field_error_proc = proc do |html_tag, _instance|
      "<span class='field_with_errors'>#{html_tag}</span>".html_safe # rubocop:disable Rails/OutputSafety
    end

    host = Rails.application.secrets.host
    config.action_mailer.default_url_options = if Rails.env.production? && host
                                                 { host: host, protocol: 'https://' }
                                               else
                                                 { host: 'localhost', protocol: 'http://', port: 3000 }
                                               end

    config.active_job.queue_adapter = :delayed_job
  end
end
