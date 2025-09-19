# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  root "application#index", as: "home"

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    sidekiq_username = ENV["SIDEKIQ_USERNAME"]
    sidekiq_password = ENV["SIDEKIQ_PASSWORD"]
    u = ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(sidekiq_username))
    p = ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(sidekiq_password))
    u & p
  end

  mount Sidekiq::Web, at: "/sidekiq", constraints: ->(_r) { ENV["ENABLE_SIDEKIQ_WEB"].downcase == "true" }

  # main api
  mount ::Api::Init, at: "/api/"

  # doc swagger
  mount GrapeSwaggerRails::Engine, as: "api_doc_v1", at: "api/doc/v1"

  match "*a", to: "application#catch_404", via: :all
end
