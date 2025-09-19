require "rufus-scheduler"

if defined?(Rails::Console) || Rails.env.local? || %w[rake racecar sidekiq].include?(
  File.split($PROGRAM_NAME).last
) || ENV["SCHEDULER"] == "false"
  return
end

s = Rufus::Scheduler.singleton

s.every "1m", overlap: false, mutex: "from_scheduler" do
  puts "TEST SCHEDULER"
end
