# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/hash_set/hash_set'

RSpec.describe HashSet do
  let(:hash_set) { HashSet.new }

  describe '#initialize' do
    it 'creates an empty hash set with default capacity and load factor' do
      expect(hash_set.length).to eq(0)
    end
  end

  describe '#set' do
    it 'adds a new key' do
      hash_set.set('key1')
      expect(hash_set.has?('key1')).to be true
    end

    it 'updates existing key' do
      hash_set.set('key1')
      hash_set.set('key1') # setting same key again
      expect(hash_set.length).to eq(1)
    end
  end

  describe '#get' do
    it 'retrieves existing key' do
      hash_set.set('key1')
      expect(hash_set.get('key1')).to eq('key1')
    end

    it 'returns nil for non-existing key' do
      expect(hash_set.get('nonexistent')).to be nil
    end
  end

  describe '#has?' do
    it 'returns true if key exists' do
      hash_set.set('key1')
      expect(hash_set.has?('key1')).to be true
    end

    it 'returns false if key does not exist' do
      expect(hash_set.has?('key2')).to be false
    end
  end

  describe '#remove' do
    it 'removes a key' do
      hash_set.set('key1')
      hash_set.remove('key1')
      expect(hash_set.has?('key1')).to be false
    end
  end

  describe '#length' do
    it 'returns number of keys' do
      hash_set.set('key1')
      hash_set.set('key2')
      expect(hash_set.length).to eq(2)
    end
  end

  describe '#clear' do
    it 'empties the hash set' do
      hash_set.set('key1')
      hash_set.clear
      expect(hash_set.length).to eq(0)
    end
  end

  describe '#keys' do
    it 'returns all keys' do
      hash_set.set('key1')
      hash_set.set('key2')
      expect(hash_set.keys).to include('key1', 'key2')
    end
  end
end
