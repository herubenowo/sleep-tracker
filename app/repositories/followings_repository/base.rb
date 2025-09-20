# frozen_string_literal: true

module FollowingsRepository
  class Base < ::ApplicationRepository
    def initialize(params)
      super(params)

      @model = ::UserFollowing
    end
  end
end
