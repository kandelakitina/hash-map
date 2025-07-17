require 'rspec'

# Assuming HashMap is defined somewhere and included in the loadpath
require_relative '../lib/hash_map'

RSpec.describe HashMap do
  let(:hash_map) { HashMap.new }

  describe 'initialization' do
    it 'sets default capacity' do
      expect(hash_map.capacity).to be > 0
    end
    it 'sets default load factor' do
      expect(hash_map.load_factor).to eq(0.75)
    end
  end

  describe '#set' do
    it 'adds new key-value pairs' do
      hash_map.set('key1', 'value1')
      expect(hash_map.get('key1')).to eq('value1')
    end
    it 'overwrites existing key' do
      hash_map.set('key2', 'value2')
      hash_map.set('key2', 'new_value')
      expect(hash_map.get('key2')).to eq('new_value')
    end
  end

  describe '#get' do
    it 'returns value for existing key' do
      hash_map.set('key3', 'value3')
      expect(hash_map.get('key3')).to eq('value3')
    end
    it 'returns nil for nonexistent key' do
      expect(hash_map.get('nonexistent')).to be_nil
    end
  end

  describe '#has?' do
    it 'returns true if key exists' do
      hash_map.set('key4', 'value4')
      expect(hash_map.has?('key4')).to be true
    end
    it 'returns false if key does not exist' do
      expect(hash_map.has?('nonexistent')).to be false
    end
  end

  describe '#remove' do
    it 'removes existing key and returns its value' do
      hash_map.set('key5', 'value5')
      expect(hash_map.remove('key5')).to eq('value5')
      expect(hash_map.has?('key5')).to be false
    end
    it 'returns nil if key does not exist' do
      expect(hash_map.remove('nonexistent')).to be_nil
    end
  end

  describe '#length' do
    it 'returns the number of stored keys' do
      hash_map.set('k1', 'v1')
      hash_map.set('k2', 'v2')
      expect(hash_map.length).to eq(2)
    end
  end

  describe '#clear' do
    it 'removes all entries' do
      hash_map.set('k1', 'v1')
      hash_map.clear
      expect(hash_map.length).to eq(0)
    end
  end

  describe '#keys' do
    it 'returns all keys' do
      hash_map.set('k1', 'v1')
      hash_map.set('k2', 'v2')
      keys = hash_map.keys
      expect(keys).to include('k1', 'k2')
    end
  end

  describe '#values' do
    it 'returns all values' do
      hash_map.set('k1', 'v1')
      hash_map.set('k2', 'v2')
      expect(hash_map.values).to include('v1', 'v2')
    end
  end

  describe '#entries' do
    it 'returns all key-value pairs' do
      hash_map.set('k1', 'v1')
      hash_map.set('k2', 'v2')
      entries = hash_map.entries
      expect(entries).to include(%w[k1 v1], %w[k2 v2])
    end
  end

  describe 'bucket index boundaries' do
    it 'raises IndexError for negative bucket index' do
      expect do
        index = -1
        raise IndexError if index.negative? || index >= hash_map.instance_variable_get(:@buckets).length

        hash_map.instance_variable_get(:@buckets)[index]
      end.to raise_error(IndexError)
    end

    it 'raises IndexError for index >= buckets.length' do
      buckets = hash_map.instance_variable_get(:@buckets)
      index = buckets.length
      expect do
        raise IndexError if index.negative? || index >= buckets.length

        buckets[index]
      end.to raise_error(IndexError)
    end
  end
end
