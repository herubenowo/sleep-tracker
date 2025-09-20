# frozen_string_literal: true

module FollowingsRepository
  class FollowUser < ::FollowingsRepository::Base
    def call
      begin
        if @model.find_by(follower_id: @params["current_user_id"], following_id: @params["following_id"]).present?
          return [false, "You are already following this user.", 409]
        end

        @model.create!(
          follower_id: @params["current_user_id"],
          following_id: @params["following_id"]
        )

        [true, nil, 201]
      rescue StandardError => e
        Rails.logger.info "::FollowingsRepository::FollowUser ERROR: #{e.message}"
        [false, "Something went wrong", 500]
      end
    end

    def self.call(params)
      new(params).call
    end
  end
end
