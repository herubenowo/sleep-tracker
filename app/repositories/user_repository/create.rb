# frozen_string_literal: true

module UserRepository
  class Create < ::UserRepository::Base
    def call
      begin
        data = nil
        ActiveRecord::Base.transaction do
          data = @model.new
          @params.map do |key, value|
            next unless @model.column_names.include?(key.to_s)
            data.send("#{key}=", value)
          end
          data.save
        end
        [ true, data, 201 ]
      rescue StandardError => e
        Rails.logger.info "UserRepository::Create ERROR: #{e.message}"
        [ false, "Something went wrong!", 500 ]
      end
    end

    def self.call(params)
      new(params).call
    end
  end
end
