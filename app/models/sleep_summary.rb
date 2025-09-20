class SleepSummary < ApplicationRecord
  after_create :set_default

  def set_default
    update_data = {}
    update_data[:total_duration_minutes] = 0 if self.total_duration_minutes.nil?
    update_data[:total_sleep_sessions] = 0 if self.total_sleep_sessions.nil?

    if update_data.present?
      self.update(update_data)
    end
  end
end
