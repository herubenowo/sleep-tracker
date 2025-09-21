# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionView::Helpers::DateHelper
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  rescue_from ActionController::RoutingError do |_exception|
    render json: { error: { errors: ["Page not found"] } }, status: 404
  end

  def index
    render json: { message: "Welcome to #{ENV.fetch("APP_NAME", "sleep-tracker-be")}" }, status: 200
  end

  def catch_404
    raise ActionController::RoutingError, params[:path]
  end
end
