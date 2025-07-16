# frozen_string_literal: true

require_relative 'linked_list'

# A class to defind hash maps
class HashMap
  attr_reader :load_factor, :capacity

  def initialize(capacity = 16, load_factor = 0.75)
    @capacity = capacity
    @load_factor = load_factor
    @buckets = capacity
  end
end
