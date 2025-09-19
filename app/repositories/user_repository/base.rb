# frozen_string_literal: true

module UserRepository
  class Base
    def initialize(params)
      raise "params is invalid" if params.class != Hash && params.class != Hashie::Mash

      @model = ::User
      @params = params
    end
  end
end
