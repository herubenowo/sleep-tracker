class CreateUserFollowings < ActiveRecord::Migration[7.1]
  def change
    create_table :user_followings do |t|
      t.references :follower
      t.references :following

      t.timestamps
    end

    # optimizing index
    add_index :user_followings, [:follower_id, :following_id], unique: true, name: "idx_user_followings_follower_id"
    add_index :user_followings, [:following_id, :follower_id], unique: true, name: "idx_user_followings_following_id"
    add_index :user_followings, [:follower_id, :created_at], name: "idx_user_followings_created_at"
  end
end
