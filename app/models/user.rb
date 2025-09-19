class User < ApplicationRecord
  # People this user follows
  has_many :active_follows, class_name: "UserFollowing", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_follows, source: :following

  # People who follow this user
  has_many :passive_follows, class_name: "UserFollowing", foreign_key: "following_id", dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower
end
