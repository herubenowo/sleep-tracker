# frozen_string_literal: true

module SleepSummaryService
  class CurrentUser
    def call
      current_user = ::User.find_by_id(@current_user_id)
      return [false, "current_user_id not found", 404] unless current_user.present?

      ::SleepSummaryRepository::CurrentUser.get(@params.merge!({"current_user_id" => @current_user_id}))
    end

    def self.call(current_user_id, params)
      new(current_user_id, params).call
    end

    def initialize(current_user_id, params)
      raise "current_user_id must be an integer" if current_user_id.class != Integer
      raise "params is invalid" if params.class != Hash && params.class != Hashie::Mash

      @current_user_id = current_user_id
      @params = params
    end
  end
end
