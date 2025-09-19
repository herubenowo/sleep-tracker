# frozen_string_literal: true

module Authentication
  class Token
    def self.verify(token)
      new(token).verify
    end

    def initialize(token)
      @token = token
    end

    def verify
      return [ false, "Invalid token", 401 ] if @token.class != String || (!@token.include?("Bearer") && !@token.include?("Basic"))
      decoded_token = Base64.strict_decode64(@token.split(" ")[1]).split(":")
      user = User.find_by(username: decoded_token[0], password: decoded_token[1])
      if user.present?
        [ true, user, 200 ]
      else
        [ false, "Unauthorized", 401 ]
      end
    end
  end
end
