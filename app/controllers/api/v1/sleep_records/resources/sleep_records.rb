# frozen_string_literal: true

class ::Api::V1::SleepRecords::Resources::SleepRecords < Grape::API
  resource "sleep-records" do
    desc "Current User Clock-In"
    post "/clock-in" do
      success, response, status_code = ::SleepRecordService::ClockIn.call(env["CURRENT_USER"].id)
      unless success
        error!(response, status_code)
      end

      env["api.response.message"] = "Success clock in, have a nice sleep!"
      present true
    end
  end
end