# frozen_string_literal: true

module UserRepository
  class Base < ::ApplicationRepository
    def initialize(params)
      super(params)

      @model = ::User
    end
  end
end
