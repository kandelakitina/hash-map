# frozen_string_literal: true

require 'set'

# A class to defind hash maps
class HashSet
  attr_reader :load_factor, :capacity

  def initialize(capacity = 16, load_factor = 0.75)
    raise ArgumentError, 'Capacity must be positive' unless capacity.positive?
    raise ArgumentError, 'load_factor must be positive' unless load_factor.positive?

    @capacity = capacity
    @load_factor = load_factor
    @buckets = Array.new(capacity) { Set.new }
  end

  def set(key)
    @buckets[hash(key)].add(key)
    update_capacity
  end

  def get(key)
    @buckets[hash(key)].include?(key) ? key : nil
  end

  def has?(key)
    @buckets.any? { |bucket| bucket.include?(key) }
  end

  def remove(key)
    @buckets[hash(key)].delete(key)
  end

  def length
    @buckets.sum(&:size)
  end

  def clear
    @buckets = Array.new(@capacity) { Set.new }
  end

  def keys
    @buckets.flat_map(&:to_a)
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
    clear

    old_buckets.each { |bucket| rehash_bucket(bucket) }
  end

  def rehash_bucket(bucket)
    bucket.each do |item|
      index = hash(item)
      @buckets[index].add(item)
    end
  end
end
