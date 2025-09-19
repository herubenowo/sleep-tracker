# frozen_string_literal: true

module UserService
  class FollowerList
    def get
      following = ::User.find_by_id(@following_id)
      return [false, "following_id not found", 404] unless following.present?

      success, response = FollowingsRepository::FollowerList.call(@params.merge!({ "following_id" => @following_id }))
      [success, response, success ? 200 : 500]
    end

    def self.get(following_id, params)
      new(following_id, params).get
    end

    def initialize(following_id, params)
      raise "following_id is invalid" if following_id.class != Integer
      raise "params is invalid" if params.class != Hash && params.class != Hashie::Mash

      @following_id = following_id
      @params = params
    end
  end
end