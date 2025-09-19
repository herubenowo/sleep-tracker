# frozen_string_literal: true

class ::Api::V1::Users::Resources::Users < Grape::API
  resource "user" do
    desc "Create User"
    params do
      requires :username, type: String, desc: "User username"
      requires :password, type: String, desc: "User password"
    end
    post "/" do
      success, response, status_code = ::UserService::Create.call(declared(params))
      unless success
        error!(response, status_code)
      end

      env["api.response.message"] = "Success create user"
      present true
    end

    desc "Current User Following List"
    params do
      optional :page, type: Integer, desc: "Page Number"
      optional :per_page, type: Integer, desc: "Per Page"
      optional :order_direction, type: String, values: %w[asc desc], default: "desc", desc: "Order Direction by created_at"
    end
    get "/me/following-list" do
      success, response, status_code = ::UserService::FollowingList.get(env["CURRENT_USER"].id, declared(params))
      unless success
        error!(response, status_code)
      end

      present :followings, response["data"], with: Grape::Presenters::Presenter
      present :meta, response["meta"], with: Grape::Presenters::Presenter
    end

    desc "Current User Follower List"
    params do
      optional :page, type: Integer, desc: "Page Number"
      optional :per_page, type: Integer, desc: "Per Page"
      optional :order_direction, type: String, values: %w[asc desc], default: "desc", desc: "Order Direction by created_at"
    end
    get "/me/follower-list" do
      success, response, status_code = ::UserService::FollowerList.get(env["CURRENT_USER"].id, declared(params))
      unless success
        error!(response, status_code)
      end

      present :followers, response["data"], with: Grape::Presenters::Presenter
      present :meta, response["meta"], with: Grape::Presenters::Presenter
    end
  end
end
