class CreateSleepRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :sleep_records do |t|
      t.references :user, null: false
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :duration_minutes

      t.timestamps
    end

    add_index :sleep_records, [:user_id, :ended_at], name: "idx_sleep_records_user_id_ended_at_null"
    add_index :sleep_records, :user_id, unique: true, where: "ended_at IS NULL"
  end
end
