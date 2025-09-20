# frozen_string_literal: true

module SleepRecordRepository
  class Base < ::ApplicationRepository
    def initialize(params)
      super(params)

      @model = ::SleepRecord
    end
  end
end
