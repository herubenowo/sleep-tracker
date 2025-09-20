# frozen_string_literal: true

module SleepRecordRepository
  class ClockOut < ::SleepRecordRepository::Base
    def call
      begin
        if $redis.present?
          unless $redis.get("sleep_records_active:#{@params["current_user_id"]}").present?
            return [false, "You have not started a sleep record", 409]
          end
        end

        data = @model.where(user_id: @params["current_user_id"], ended_at: nil).last
        unless data.present?
          return [false, "You have not started a sleep record", 409]
        end

        ActiveRecord::Base.transaction do
          data.ended_at = Time.now; duration_minutes = 0
          ::Utility.split_duration_by_day(data.started_at, data.ended_at).map do |date, duration|
            summary = ::SleepSummary.find_or_create_by(user_id: @params["current_user_id"], date: date)
            ::SleepSummary.where(id: summary.id).update_all(
              "total_sleep_sessions = total_sleep_sessions + 1, total_duration_minutes = total_duration_minutes + #{duration.to_i}"
            )
            duration_minutes += duration.to_i
          end

          data.duration_minutes = duration_minutes
          data.save

          if $redis.present?
            $redis.del("sleep_records_active:#{@params["current_user_id"]}")
          end
        end

        [true, nil, 201]
      rescue StandardError => e
        Rails.logger.info "SleepRecordRepository::ClockOut ERROR: #{e.message}"
        [false, "Something went wrong", 500]
      end
    end

    def self.call(params)
      new(params).call
    end
  end
end
