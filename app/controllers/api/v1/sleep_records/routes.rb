# frozen_string_literal: true

module Api
  module V1
    module SleepRecords
      class Routes < Grape::API
        formatter :json, SuccessFormatter
        error_formatter :json, ErrorFormatter

        mount ::Api::V1::SleepRecords::Resources::SleepRecords
      end
    end
  end
end