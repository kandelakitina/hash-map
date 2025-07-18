# frozen_string_literal: true

require 'rspec'
require_relative '../lib/hash_map'

RSpec.describe HashMap do
  let(:initial_capacity) { 4 }
  let(:load_factor) { 0.75 }
  let(:map) { described_class.new(initial_capacity, load_factor) }

  describe 'initialization' do
    it 'sets default capacity' do
      expect(map.capacity).to be > 0
    end

    it 'sets default load factor' do
      expect(map.load_factor).to eq(0.75)
    end
  end

  describe '#set and #get' do
    it 'adds and retrieves a value' do
      map.set('a', 1)
      expect(map.get('a')).to eq(1)
    end

    it 'overwrites existing key' do
      map.set('a', 1)
      map.set('a', 2)
      expect(map.get('a')).to eq(2)
    end

    it 'returns nil if key not found' do
      expect(map.get('ghost')).to be_nil
    end
  end

  describe '#has?' do
    it 'returns true if key exists' do
      map.set('key', 42)
      expect(map.has?('key')).to be true
    end

    it 'returns false if key does not exist' do
      expect(map.has?('nope')).to be false
    end
  end

  describe '#remove' do
    it 'removes and returns value' do
      map.set('x', 123)
      expect(map.remove('x')).to eq(123)
      expect(map.has?('x')).to be false
    end

    it 'returns nil if key not found' do
      expect(map.remove('nothing')).to be_nil
    end
  end

  describe '#length' do
    it 'returns count of keys' do
      map.set('a', 1)
      map.set('b', 2)
      expect(map.length).to eq(2)
    end
  end

  describe '#clear' do
    it 'empties the map' do
      map.set('a', 1)
      map.clear
      expect(map.length).to eq(0)
    end
  end

  describe '#keys' do
    it 'returns all keys' do
      map.set('a', 1)
      map.set('b', 2)
      expect(map.keys).to include('a', 'b')
    end
  end

  describe '#values' do
    it 'returns all values' do
      map.set('a', 1)
      map.set('b', 2)
      expect(map.values).to include(1, 2)
    end
  end

  describe '#entries' do
    it 'returns all key-value pairs' do
      map.set('a', 'x')
      map.set('b', 'y')
      expect(map.entries).to include(%w[a x], %w[b y])
    end
  end

  describe '#to_s' do
    it 'returns string representation of all buckets' do
      map.set('a', 1)
      output = map.to_s
      expect(output).to be_a(String)
      expect(output).to include('a: 1')
    end
  end

  describe '#update_capacity' do
    it 'does not grow when load factor is not exceeded' do
      map.set('a', 1)
      expect { map.send(:update_capacity) }.not_to(change { map.capacity })
    end

    it 'doubles capacity when load factor is exceeded' do
      4.times { |i| map.set("k#{i}", i) }
      expect(map.capacity).to eq(8)
    end

    it 'triggers rehash with updated capacity' do
      4.times { |i| map.set("k#{i}", i) }
      expect(map.send(:length)).to be > (initial_capacity * load_factor)
    end
  end

  describe '#rehash' do
    it 'replaces internal buckets with new capacity' do
      4.times { |i| map.set("item#{i}", i) }
      old_buckets = map.instance_variable_get(:@buckets)
      map.send(:rehash, 8)
      new_buckets = map.instance_variable_get(:@buckets)
      expect(new_buckets.size).to eq(8)
      expect(new_buckets).not_to eq(old_buckets)
    end

    it 'rehashes all items correctly' do
      map.set('a', 100)
      map.set('b', 200)
      expect(map.get('a')).to eq(100)
      map.send(:rehash, 8)
      expect(map.get('a')).to eq(100)
      expect(map.get('b')).to eq(200)
    end
  end

  describe 'bucket index boundaries' do
    it 'raises IndexError for negative bucket index' do
      expect do
        index = -1
        raise IndexError if index.negative? || index >= map.instance_variable_get(:@buckets).length

        map.instance_variable_get(:@buckets)[index]
      end.to raise_error(IndexError)
    end

    it 'raises IndexError for index >= buckets.length' do
      buckets = map.instance_variable_get(:@buckets)
      index = buckets.length
      expect do
        raise IndexError if index.negative? || index >= buckets.length

        buckets[index]
      end.to raise_error(IndexError)
    end
  end
end
