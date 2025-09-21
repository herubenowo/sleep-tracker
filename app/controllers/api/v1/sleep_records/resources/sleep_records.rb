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
      present :sleep_records, response, with: Grape::Presenters::Presenter
    end

    desc "Current User Clock-Out"
    post "/clock-out" do
      success, response, status_code = ::SleepRecordService::ClockOut.call(env["CURRENT_USER"].id)
      unless success
        error!(response, status_code)
      end

      env["api.response.message"] = "Success clock out, have a nice day!"
      present true
    end

    namespace "summary" do
      params do
        optional :page, type: Integer, desc: "Page Number"
        optional :per_page, type: Integer, desc: "Per Page"
        optional :start_date, type: Date
        optional :end_date, type: Date
      end
      post "/me" do
        success, response, status_code = ::SleepSummaryService::CurrentUser.call(env["CURRENT_USER"].id, declared(params))
        unless success
          error!(response, status_code)
        end

        present :summary, response["data"], with: Grape::Presenters::Presenter
        present :meta, response["meta"], with: Grape::Presenters::Presenter
      end

      params do
        optional :page, type: Integer, desc: "Page Number"
        optional :per_page, type: Integer, desc: "Per Page"
        optional :start_date, type: Date
        optional :end_date, type: Date
      end
      post "/following" do
        success, response, status_code = ::SleepSummaryService::CurrentUserFollowing.call(env["CURRENT_USER"].id, declared(params))
        unless success
          error!(response, status_code)
        end

        present :summary, response["data"], with: Grape::Presenters::Presenter
        present :meta, response["meta"], with: Grape::Presenters::Presenter
      end
    end
  end
end