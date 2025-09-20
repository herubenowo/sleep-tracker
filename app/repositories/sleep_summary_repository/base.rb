# frozen_string_literal: true

module SleepSummaryRepository
  class Base < ::ApplicationRepository
    def initialize(params)
      super(params)

      @model = ::SleepSummary
    end

    private
    def current_user_id
      @params["current_user_id"]
    end

    def start_date_filter
      @params["start_date"] || Date.today - 7.days
    end

    def end_date_filter
      @params["end_date"] || Date.today
    end

    def pagination_page_filter
      @params["page"] || 1
    end

    def pagination_per_page_filter
      @params["per_page"] || 10
    end
  end
end
