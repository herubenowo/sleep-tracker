# frozen_string_literal: true

module SleepRecordRepository
  class ClockIn < ::SleepRecordRepository::Base
    def call
      begin
        already_clocked_in = false
        if $redis.present?
          if $redis.get("sleep_records_active:#{@params["current_user_id"]}").present?
            already_clocked_in = true
          end
        else
          if @model.where(user_id: @params["current_user_id"], ended_at: nil).present?
            already_clocked_in = true
          end
        end

        if already_clocked_in
          return [true, clocked_in_data, 201]
        end

        ActiveRecord::Base.transaction do
          @model.create(
            user_id: @params["current_user_id"],
            started_at: Time.now,
          )

          if $redis.present?
            $redis.set("sleep_records_active:#{@params["current_user_id"]}", "1")
          end
        end
        [true, clocked_in_data, 201]
      rescue StandardError => e
        Rails.logger.info "SleepRecordRepository::ClockIn ERROR: #{e.message}"
        [false, "Something went wrong", 500]
      end
    end

    def self.call(params)
      new(params).call
    end

    private
    def clocked_in_data
      @model.where(user_id: @params["current_user_id"]).order(created_at: :desc).map do |row|
        {
          "clocked_in_time" => row["started_at"],
          "clocked_out_time" => row["ended_at"],
          "sleep_duration_minutes" => row["duration_minutes"]
        }
      end
    end
  end
end