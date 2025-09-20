# frozen_string_literal: true

module SleepSummaryRepository
  class CurrentUserFollowing < ::SleepSummaryRepository::Base
    def get
      begin
        current_user = ::User.find_by_id(current_user_id)
        return [false, "current_user not found", 404] unless current_user.present?

        total = @model.
          select("id").
          where(
            "user_id IN (:user_ids) AND date BETWEEN :start_date AND :end_date",
            user_ids: current_user.followings_user_id,
            start_date: start_date_filter,
            end_date: end_date_filter
          ).count

        data = @model
          .
          select("users.username AS username, sleep_summaries.date, sleep_summaries.total_duration_minutes, sleep_summaries.total_sleep_sessions").
          where(
            "user_id IN (:user_ids) AND date BETWEEN :start_date AND :end_date",
            user_ids: current_user.followings_user_id,
            start_date: start_date_filter,
            end_date: end_date_filter
          ).joins(:user).
          order("total_duration_minutes DESC, date ASC, username ASC").page(pagination_page_filter).per(pagination_per_page_filter)

        [
          true,
          {

            "data" => data.map do |row|
              {
                "username" => row["username"],
                "date" => row["date"],
                "total_duration_minutes" => row["total_duration_minutes"],
                "total_sleep_sessions" => row["total_sleep_sessions"],
              }
            end,
            "meta" => handle_meta(pagination_page_filter, pagination_per_page_filter, total)
          },
          200
        ]
      rescue StandardError => e
        Rails.logger.info "SleepSummaryRepository::FollowingWithRedis ERROR: #{e.message}"
        [false, "Something went wrong", 500]
      end
    end

    def self.get(params)
      new(params).get
    end
  end
end
