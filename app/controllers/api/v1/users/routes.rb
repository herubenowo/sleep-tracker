# frozen_string_literal: true

module Api
  module V1
    module Users
      class Routes < Grape::API
        formatter :json, SuccessFormatter
        error_formatter :json, ErrorFormatter

        mount ::Api::V1::Users::Resources::Users
      end
    end
  end
end