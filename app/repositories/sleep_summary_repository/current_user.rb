# frozen_string_literal: true

module SleepSummaryRepository
  class CurrentUser < ::SleepSummaryRepository::Base
    def get
      begin
        total = @model.
          select(:id).
          where(
            "user_id = :user_id AND date BETWEEN :start_date AND :end_date",
            user_id: current_user_id,
            start_date: start_date_filter,
            end_date: end_date_filter
          ).count

        data = @model.
          select("date, total_duration_minutes, total_sleep_sessions").
          where(
            "user_id = :user_id AND date BETWEEN :start_date AND :end_date",
            user_id: current_user_id,
            start_date: start_date_filter,
            end_date: end_date_filter
          ).
          order("total_duration_minutes DESC, date ASC").page(pagination_page_filter).per(pagination_per_page_filter)

        [
          true,
          {
            "data" => data.map do |row|
              {
                "record_date" => row["date"],
                "total_duration_minutes" => row["total_duration_minutes"],
                "total_sleep_sessions" => row["total_sleep_sessions"]
              }
            end,
            "meta" => handle_meta(pagination_page_filter, pagination_per_page_filter, total)
          },
          200
        ]
      rescue StandardError => e
        Rails.logger.info "::SleepSummaryRepository::CurrentUser ERROR: #{e.message}"
        [false, "Something went wrong", 500]
      end
    end

    def self.get(params)
      new(params).get
    end
  end
end
