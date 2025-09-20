class CreateSleepSummaries < ActiveRecord::Migration[7.1]
  def change
    create_table :sleep_summaries do |t|
      t.references :user, null: false
      t.date :date
      t.integer :total_duration_minutes
      t.integer :total_sleep_sessions

      t.timestamps
    end

    add_index :sleep_summaries, [:user_id, :date], unique: true, name: "idx_sleep_summaries_user_id_date"
    add_index :sleep_summaries, [:user_id, :total_duration_minutes, :date], name: "idx_sleep_summaries_total_duration_date"
    add_index :sleep_summaries, [:user_id, :date, :total_duration_minutes], name: "idx_sleep_summaries_date_total_duration"
  end
end
