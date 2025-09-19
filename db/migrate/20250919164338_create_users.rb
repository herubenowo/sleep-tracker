class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, [ :username, :password ], name: "idx_users_username_password"
  end
end
