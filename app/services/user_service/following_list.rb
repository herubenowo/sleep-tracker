# frozen_string_literal: true

module UserService
  class FollowingList
    def get
      follower = ::User.find_by_id(@follower_id)
      return [false, "follower_id not found", 404] unless follower.present?

      success, response = FollowingsRepository::FollowingList.call(@params.merge!({ "follower_id" => @follower_id }))
      [success, response, success ? 200 : 500]
    end

    def self.get(follower_id, params)
      new(follower_id, params).get
    end

    def initialize(follower_id, params)
      raise "follower_id is invalid" if follower_id.class != Integer
      raise "params is invalid" if params.class != Hash && params.class != Hashie::Mash

      @follower_id = follower_id
      @params = params
    end
  end
end