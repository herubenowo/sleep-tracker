# frozen_string_literal: true

require "sidekiq-unique-jobs"
require "sidekiq"

ActiveSupport::Reloader.to_prepare do
  redis_url = ENV["REDISTOGO_URL"]
  redis_driver = ENV.fetch("REDIS_DRIVER", "hiredis").to_sym

  # High-performance Redis configuration
  redis_config = {
    url: redis_url,
    # Reduced timeouts for faster operations
    read_timeout: ENV["REDIS_TIMEOUT"].present? ? ENV["REDIS_TIMEOUT"].to_i : 3,
    write_timeout: ENV["REDIS_TIMEOUT"].present? ? ENV["REDIS_TIMEOUT"].to_i : 3,
    connect_timeout: 2,
    # Increased reconnect attempts for reliability
    reconnect_attempts: ENV["REDIS_RECONNECT"].present? ? ENV["REDIS_RECONNECT"].to_i : 3,
    # Use hiredis for maximum performance
    driver: redis_driver,
    # Connection pooling for better concurrency
    size: ENV.fetch("REDIS_POOL_SIZE", 25).to_i,
    # Connection pool timeout
    pool_timeout: 5
  }

  Sidekiq.configure_server do |config|
    config.redis = redis_config.merge(
      # Server-specific optimizations
      size: ENV.fetch("REDIS_SERVER_POOL_SIZE", 50).to_i
    )
  end

  Sidekiq.configure_client do |config|
    config.redis = redis_config.merge(
      # Client-specific optimizations
      size: ENV.fetch("REDIS_CLIENT_POOL_SIZE", 10).to_i
    )
  end
end

Sidekiq::DelayExtensions.enable_delay!

module Sidekiq::Extensions
end

Sidekiq::Extensions::DelayedClass = Sidekiq::DelayExtensions::DelayedClass
Sidekiq::Extensions::DelayedModel = Sidekiq::DelayExtensions::DelayedModel
Sidekiq::Extensions::DelayedMailer = Sidekiq::DelayExtensions::DelayedMailer