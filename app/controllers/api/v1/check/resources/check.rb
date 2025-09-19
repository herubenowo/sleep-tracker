# frozen_string_literal: true

class ::Api::V1::Check::Resources::Check < Grape::API
  resource "check" do
    desc "Check Connection Endpoint"
    get "/" do
      env["api.response.message"] = "Success Check Connection"
      present ::Connection::Check.call, with: Grape::Presenters::Presenter
    end
  end
end
