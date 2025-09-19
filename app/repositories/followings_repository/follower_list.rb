# frozen_string_literal: true

module FollowingsRepository
  class FollowerList < ::FollowingsRepository::Base
    def call
      begin
        user = ::User.find_by_id(@params["following_id"])
        return [false, nil] unless user.present?
        page = @params["page"] || 1
        per_page = @params["per_page"] || 10
        total = user.followers.select(:id).count
        data = user.followers.order("user_followings.created_at #{(@params["order_direction"] || "desc").upcase}").page(page).per(per_page).select(:id, :username).map do |u|
          {
            "id" => u.id,
            "username" => u.username
          }
        end

        [
          true,
          {
            "data" => data,
            "meta" => handle_meta(page, per_page, total)
          }
        ]
      rescue StandardError => e
        Rails.logger.info "::FollowingsRepository::FollowerList ERROR: #{e.message}"
        [false, "Something went wrong"]
      end
    end

    def self.call(params)
      new(params).call
    end
  end
end
