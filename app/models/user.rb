class User < ApplicationRecord
  # People this user follows
  has_many :active_follows, class_name: "UserFollowing", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_follows, source: :following

  # People who follow this user
  has_many :passive_follows, class_name: "UserFollowing", foreign_key: "following_id", dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower

  def followings_user_id
    data = nil
    if $redis.present?
      data = $redis.get("followings_user_id:#{self.id}")
      if data.present?
        data = JSON.parse(data)
      end
    end

    if data.nil?
      data = self.following.pluck(:id)
      if data.present? && $redis.present?
        $redis.set("followings_user_id:#{self.id}", data.to_json)
      end
    end

    data
  end

  def reset_followings_user_id
    return unless $redis.present?

    $redis.del("followings_user_id:#{self.id}")
    self.followings_user_id
  end
end
