require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load if Rails.env.test?

module ResaParisLiberte
  # Base Application
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those
    # specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Devise mailer options
    config.action_mailer.default_url_options = {
      host: ENV['HOST_WITH_PORT'].to_s
    }

    # Autoload
    config.autoload_paths += %W(#{config.root}/app/models/rooms)
    config.autoload_paths += %W(#{config.root}/app/models/time_account_lines)
    config.autoload_paths += %W(#{config.root}/app/services)
    config.autoload_paths += %W(#{config.root}/app/presenters)

    # Timezone
    config.time_zone = ActiveSupport::TimeZone::MAPPING['Paris']
    config.active_record.default_timezone = :utc

    # Active job
    config.active_job.queue_adapter = :delayed_job
  end
end
