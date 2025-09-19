# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    def self.batch_update_from_param(params, id)
        error = nil
        data = self.find id
        self.column_names.each do |x|
            if !params[x.to_sym].nil? || !params[x].nil?
                data.send("#{x}=", params[x.to_sym])
            end
        end

        unless data.save
            error = data.errors.full_messages.join(", ")
        end
        error
    end

    def self.new_from_params(params)
        model = self.new
        self.column_names.each do |x|
            unless params[x.to_sym].nil? || params[x].nil?
                model[x.to_sym] = params[x.to_sym]
            end
        end
        model
    end
end
