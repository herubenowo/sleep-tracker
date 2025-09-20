# frozen_string_literal: true

class Utility
  def self.split_duration_by_day(started_at, ended_at)
    return {} if ended_at <= started_at

    result = Hashie::Mash.new({})
    begin
      current = started_at
      while current < ended_at
        day_end = current.end_of_day
        segment_end = [day_end, ended_at].min
        minutes = ((segment_end - current) / 60).ceil
        if result[current.to_date].present?
          result[current.to_date] += minutes
        else
          result[current.to_date] = minutes
        end
        current = segment_end + 1.second
      end

      result
    rescue StandardError => _
      result
    end
  end
end