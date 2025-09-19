# frozen_string_literal: true

module Api
  class Init < Grape::API
    # Create log in console
    insert_after Grape::Middleware::Formatter, Grape::Middleware::Logger,
                 logger: Logger.new(STDERR),
                 filter: Class.new {
                   def filter(opts)
                     opts.reject { |k, _| k.to_s == "password" }
                   end
                 }.new,
                 headers: %w[version cache-control]

    # Build params using object
    include Grape::Extensions::Hashie::Mash::ParamBuilder

    # Build params using object
    include Grape::Extensions::Hashie::Mash::ParamBuilder

    mount ::Api::V1::Main
  end
end
