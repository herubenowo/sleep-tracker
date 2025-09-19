# frozen_string_literal: true

module ErrorFormatter
  def self.call(message, _backtrace, _options, env, _original_exception)
    status_code = env["api.response.code"].present? ? env["api.response.code"] : env["api.endpoint"].status

    if status_code == 401 || Rails.env.development?
      error_message = message
    else
      if status_code == 500
        error_message = "Internal Server Error"
      else
        error_message = "Invalid parameter / body"
      end
    end


    unmask_error_message = ENV["UNMASK_ERROR_MESSAGE"] == "true"
    response = {
      error: {
        code: [200, 201].include?(status_code) ? 422 : status_code,
        errors: [unmask_error_message ? message : error_message]
      }
    }

    response.to_json
  end
end
