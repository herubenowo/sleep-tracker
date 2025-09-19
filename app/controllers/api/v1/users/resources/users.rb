# frozen_string_literal: true

class ::Api::V1::Users::Resources::Users < Grape::API
  resource "user" do
    params do
      requires :username, type: String, desc: "User username"
      requires :password, type: String, desc: "User password"
    end
    post "/" do
      success, response, status_code = ::UserService::Create.call(params)
      unless success
        error!(response, status_code)
      end

      env["api.response.message"] = "Success create user"
      present true
    end
  end
end
