module Connection
  class Check
    def self.call
      {
        "api_version" => "1",
        "db_connection" => ActiveRecord::Base.connection.active? ? "UP" : "DOWN",
        "redis_connection" => $redis.present? ? "#{$redis.ping.eql?("PONG") ? "UP" : "DOWN"}" : "DISABLED"
      }
    end
  end
end
