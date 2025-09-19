# frozen_string_literal: true

require_relative "boot"

require "rails/all"
require "active_support/parameter_filter"
require "net/http"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DciMiddleware
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1
    config.autoload_paths += %w[lib/]
    # config.autoload_paths += %W(#{config.root}/app/controllers/params)
    config.active_job.queue_adapter = :sidekiq
    config.time_zone = "Asia/Jakarta"
    config.generators do |g|
      g.orm :active_record
    end

    config.middleware.delete Rack::ETag if Rails.env.development?
    config.i18n.load_path += Dir[Rails.root.join("my", "locales", "*.{rb,yml}")]
    config.i18n.default_locale = (ENV["DEFAULT_LOCALE"] || "en").to_sym
    config.i18n.available_locales = [:id, :en]

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

      # Configuration for the application, engines, and railties goes here.
      #
      # These settings can be overridden in specific environments using the files
      # in config/environments, which are processed later.
      #
      # config.time_zone = "Central Time (US & Canada)"
      # config.eager_load_paths << Rails.root.join("extras")
  end
end
