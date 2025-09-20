# frozen_string_literal: true

module UserRepository
  class FindUsername < ::UserRepository::Base
    def call
      begin
        [ true, @model.find_by_username(@params["username"]), 200 ]
      rescue StandardError => e
        Rails.logger.info "UserRepository::FindUsername ERROR: #{e.message}"
        [ false, "Something went wrong!", 500 ]
      end
    end

    def self.call(params)
      new(params).call
    end
  end
end
