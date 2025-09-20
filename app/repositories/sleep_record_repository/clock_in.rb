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
          return [false, "Already clocked in.", 409]
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
        [true, nil, 201]
      rescue StandardError => e
        Rails.logger.info "SleepRecordRepository::ClockIn ERROR: #{e.message}"
        [false, "Something went wrong", 500]
      end
    end

    def self.call(params)
      new(params).call
    end
  end
end