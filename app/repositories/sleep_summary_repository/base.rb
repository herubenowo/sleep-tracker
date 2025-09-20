# frozen_string_literal: true

module SleepSummaryRepository
  class Base < ::ApplicationRepository
    def initialize(params)
      super(params)

      @model = ::SleepSummary
    end
  end
end
