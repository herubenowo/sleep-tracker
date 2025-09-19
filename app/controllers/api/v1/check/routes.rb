# frozen_string_literal: true

module Api
  module V1
    module Check
      class Routes < Grape::API
        formatter :json, SuccessFormatter
        error_formatter :json, ErrorFormatter

        mount ::Api::V1::Check::Resources::Check
      end
    end
  end
end