# frozen_string_literal: true

require_relative 'linked_list'

# A class to defind hash maps
class HashMap
  attr_reader :load_factor, :capacity

  def initialize(capacity = 16, load_factor = 0.75)
    # raise ArgumentError, 'Capacity must be positive' unless capacity.positive?
    # raise ArgumentError, 'load_factor must be positive' unless load_factor.positive?

    @capacity = capacity
    @load_factor = load_factor
    @buckets = Array.new(capacity) { LinkedList.new }
  end

  def set(key, value)
    index = hash(key)
    node = Node.new(key, value)
    @buckets[index].insert_or_update(node)
  end

  def get(key)
    index = hash(key)
    node = @buckets[index]&.find { |n| n.key == key }
    node&.value
  end

  private

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = (prime_number * hash_code) + char.ord }

    hash_code % @buckets.length
  end
end
