# frozen_string_literal: true

module SleepRecordService
  class ClockOut
    def call
      current_user = ::User.find_by_id(@current_user_id)
      return [false, "current_user_id not found", 404] unless current_user.present?

      ::SleepRecordRepository::ClockOut.call(Hashie::Mash.new({"current_user_id" => @current_user_id}))
    end

    def self.call(current_user_id)
      new(current_user_id).call
    end

    def initialize(current_user_id)
      raise "current_user_id must be integer" if current_user_id.class != Integer

      @current_user_id = current_user_id
    end
  end
end
