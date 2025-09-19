# frozen_string_literal: true

module FollowingsRepository
  class Base
    def initialize(params)
      raise "params is invalid" if params.class != Hash && params.class != Hashie::Mash

      @model = ::UserFollowing
      @params = params
    end

    def handle_meta(page, per_page, total)
      {
        "pagination" => {
          "page" => page,
          "per_page" => per_page,
          "total" => total
        }
      }
    end
  end
end
