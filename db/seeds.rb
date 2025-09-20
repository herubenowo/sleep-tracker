unless User.exists?
  User.create!(username: "admin", password: "admin")
end

require 'faker'

puts "Seeding data..."

# ====== USERS ======
puts "Creating users..."
user_count = 10000
users = []

user_count.times do |i|
  users << {
    username: Faker::Internet.unique.username(specifier: 5..8),
    password: "password",
    created_at: Time.current,
    updated_at: Time.current
  }
end

User.insert_all(users)
user_ids = User.pluck(:id)
puts "Created #{user_ids.size} users."

# ====== USER FOLLOWINGS ======
puts "Creating followings..."
followings = []
user_ids.each do |follower_id|
  # Each user follows 5 random other users
  following_sample = user_ids.sample(5) - [follower_id]
  following_sample.each do |following_id|
    followings << {
      follower_id: follower_id,
      following_id: following_id,
      created_at: Time.current,
      updated_at: Time.current
    }
  end
end

UserFollowing.insert_all(followings)
puts "Created #{followings.size} user followings."

# ====== SLEEP RECORDS ======
puts "Creating sleep records..."
sleep_records = []
user_ids.each do |user_id|
  rand(5..15).times do
    started_at = Faker::Time.between(from: 30.days.ago, to: Time.current)
    duration_minutes = rand(300..540) # 5 - 9 hours
    ended_at = started_at + duration_minutes.minutes

    sleep_records << {
      user_id: user_id,
      started_at: started_at,
      ended_at: ended_at,
      duration_minutes: duration_minutes,
      created_at: Time.current,
      updated_at: Time.current
    }
  end
end

# Batch insert to avoid memory issues
sleep_records.each_slice(1000) do |batch|
  SleepRecord.insert_all(batch)
end
puts "Created #{sleep_records.size} sleep records."

# ====== SLEEP SUMMARIES ======
puts "Creating sleep summaries..."
sleep_summaries = []
user_ids.each do |user_id|
  (0..30).each do |day_offset|
    date = day_offset.days.ago.to_date
    total_duration = rand(300..540)
    total_sessions = rand(1..3)

    sleep_summaries << {
      user_id: user_id,
      date: date,
      total_duration_minutes: total_duration,
      total_sleep_sessions: total_sessions,
      created_at: Time.current,
      updated_at: Time.current
    }
  end
end

# Batch insert
sleep_summaries.each_slice(1000) do |batch|
  SleepSummary.insert_all(batch)
end
puts "Created #{sleep_summaries.size} sleep summaries."

puts "Seeding completed!"
