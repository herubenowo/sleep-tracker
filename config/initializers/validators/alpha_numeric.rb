# frozen_string_literal: true

class AlphaNumeric < Grape::Validations::Base
  def validate_param!(attr_name, params)
    unless !params[attr_name].present? || params[attr_name] =~ /\A[[:alnum:]]+\z/
      raise Grape::Exceptions::Validation.new(params: [@scope.full_name(attr_name)], message: "must consist of alpha-numeric characters")
    end
  end
end
