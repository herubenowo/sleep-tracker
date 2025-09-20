# frozen_string_literal: true

if ENV["REDIS_HOST"].present? && ENV["REDIS_PORT"].present? && ENV["REDIS_DB"].present?
  $redis = Redis.new(
    host: ENV["REDIS_HOST"],
    port: ENV["REDIS_PORT"],
    db: ENV["REDIS_DB"],
    password: ENV["REDIS_PASSWORD"])
end