# frozen_string_literal: true

require_relative 'linked_list'
require 'pry'

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
    target_bucket = @buckets[index]
    target_bucket.insert_or_update(key, value)
    update_capacity
  end

  def get(key)
    node = @buckets[hash(key)].find_by_key(key)
    node&.value
  end

  def has?(key)
    @buckets.any? { |bucket| bucket.contains?(key) }
  end

  def remove(key)
    @buckets[hash(key)].remove_by_key(key)
  end

  def length
    @buckets.reduce(0) { |sum, bucket| sum + bucket.size }
  end

  def clear
    @buckets = Array.new(capacity) { LinkedList.new }
  end

  def keys
    @buckets.flat_map(&:keys)
  end

  def values
    @buckets.flat_map(&:values)
  end

  def entries
    @buckets.flat_map(&:entries)
  end

  def to_s
    @buckets.map(&:to_s).join("\n")
  end

  private

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = (prime_number * hash_code) + char.ord }

    hash_code % @buckets.length
  end

  def update_capacity
    return unless length > (@capacity * @load_factor)

    rehash(@capacity * 2)
  end

  def rehash(new_capacity)
    old_buckets = @buckets
    @capacity = new_capacity
    @buckets = Array.new(@capacity) { LinkedList.new }

    old_buckets.each do |bucket|
      rehash_bucket(bucket)
    end
  end

  def rehash_bucket(bucket)
    bucket.each do |node|
      index = hash(node.key)
      @buckets[index].insert_or_update(node.key, node.value)
    end
  end
end
