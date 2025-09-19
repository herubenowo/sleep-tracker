# frozen_string_literal: true

module Api
  module V1
    class Main < Grape::API
      include Config
      version "v1", using: :path

      # Exception Handlers
      include ExceptionHandlers unless ENV.fetch("DEBUGGING", "false").eql?("true")

      # Helpers
      include Helpers

      before do
        auth_token = request.headers["Authorization"]
        unless auth_token.present?
          error!("401 Unauthorized", 401)
        end

        success, response, status_code = ::Authentication::Token.verify(auth_token)
        unless success
          error!(response, status_code)
        end

        env["CURRENT_USER"] = response
      end

      # Mounting Modules Api
      mount ::Api::V1::Check::Routes
      mount ::Api::V1::Users::Routes

      # Swagger config
      add_swagger_documentation(
        api_version: "v1",
        doc_version: "v1",
        hide_documentation_path: true,
        mount_path: "documentation.json",
        hide_format: true,
        info: {
          title: "API V1 Collection",
          description: "A collection for API V1 Endpoint"
        }
      )
    end
  end
end
