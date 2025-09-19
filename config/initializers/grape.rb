# frozen_string_literal: true

class GrapeHeader < Hash
  def initialize(hash)
    @hash = hash.transform_keys(&:downcase)
    super
  end

  def [](key)
    @hash[key.downcase]
  end

  def []=(key, value)
    @hash[key.downcase] = value
  end

  def to_hash = @hash
end

Grape::Request.class_eval do
  alias_method :old_headers, :headers

  def headers = GrapeHeader.new(old_headers)
end
