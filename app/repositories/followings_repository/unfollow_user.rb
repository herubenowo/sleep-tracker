# frozen_string_literal: true

module FollowingsRepository
  class UnfollowUser < ::FollowingsRepository::Base
    def call
      begin
        following = @model.find_by(follower_id: @params["current_user_id"], following_id: @params["following_id"])
        unless following.present?
          return [false, "You are not following this user.", 409]
        end

        following.destroy
        [true, nil, 201]
      rescue StandardError => e
        Rails.logger.info "FollowingsRepository::UnfollowUser ERROR: #{e.message}"
        [false, "Something went wrong", 500]
      end
    end

    def self.call(params)
      new(params).call
    end
  end
end