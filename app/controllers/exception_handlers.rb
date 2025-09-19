# frozen_string_literal: true

module ExceptionHandlers
  include ActiveRecord

  def self.included(base)
    base.instance_eval do
      rescue_from :all do |e|
        if e.class.name == "Grape::Exceptions::ValidationErrors"
          code = 422
          message = e.as_json_custom
        elsif e.class.name == "RuntimeError" && e.message == "Invalid base64 string"
          code = 406
          message = ["401 Unauthorized"]
        elsif e.class.name == ActiveRecord::RecordNotFound
          exception_handler(e.message, 404)
          code = 404
          message = [e.message]
        elsif e.class.name == "WineBouncer::Errors::OAuthForbiddenError"
          code = 403
          message = ["Access Forbidden"]
        elsif e.class.name == "WineBouncer::Errors::OAuthUnauthorizedError"
          code = 401
          message = ["Invalid Access token"]
        elsif e.class.name == "ActiveRecord::RecordInvalid"
          code = 422
          message = [e.try(:message)]
        else
          code = 500
          message = e.to_s
          env["debug_error_message"] = message unless env["debug_error_message"].present?
          message = [ENV.fetch("DEBUGGING", "false") == "true" ? message : "Oopps something bad happens!"]
        end

        if code == 401 || Rails.env.development?
          masking_error_message = message
        else
          if code == 500
            masking_error_message = ["Internal Server Error"]
          else
            masking_error_message = ["Invalid parameter / body"]
          end
        end

        unmask_error_message = ENV["UNMASK_ERROR_MESSAGE"] == "true"

        results = {
          error: {
            code: code,
            errors: unmask_error_message ? message : masking_error_message
          }
        }

        rack_response results.to_json, code
      end
    end
  end
end
