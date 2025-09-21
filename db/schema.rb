# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_09_20_050833) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sleep_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer "duration_minutes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "idx_sleep_records_user_id_created_at"
    t.index ["user_id", "ended_at"], name: "idx_sleep_records_user_id_ended_at"
    t.index ["user_id"], name: "idx_sleep_records_user_id_ended_at_null", unique: true, where: "(ended_at IS NULL)"
    t.index ["user_id"], name: "index_sleep_records_on_user_id"
  end

  create_table "sleep_summaries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "date"
    t.integer "total_duration_minutes"
    t.integer "total_sleep_sessions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "date", "total_duration_minutes"], name: "idx_sleep_summaries_date_total_duration"
    t.index ["user_id", "date"], name: "idx_sleep_summaries_user_id_date", unique: true
    t.index ["user_id", "total_duration_minutes", "date"], name: "idx_sleep_summaries_total_duration_date"
    t.index ["user_id"], name: "index_sleep_summaries_on_user_id"
  end

  create_table "user_followings", force: :cascade do |t|
    t.bigint "follower_id"
    t.bigint "following_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id", "created_at"], name: "idx_user_followings_created_at"
    t.index ["follower_id", "following_id"], name: "idx_user_followings_follower_id", unique: true
    t.index ["follower_id"], name: "index_user_followings_on_follower_id"
    t.index ["following_id", "follower_id"], name: "idx_user_followings_following_id", unique: true
    t.index ["following_id"], name: "index_user_followings_on_following_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "idx_users_created_at"
    t.index ["username", "created_at"], name: "idx_users_username_created_at"
    t.index ["username", "password"], name: "idx_users_username_password"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
