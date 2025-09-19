# frozen_string_literal: true

module UserService
  class Create
    def call
      success, data, _ = ::UserRepository::FindUsername.call(@params)
      unless success
        return [ false, data, 500 ]
      end

      if data.present?
        return [ false, "username already exists", 422 ]
      end

      ::UserRepository::Create.call(@params)
    end

    def self.call(params)
      new(params).call
    end

    def initialize(params)
      @params = params
    end
  end
end
