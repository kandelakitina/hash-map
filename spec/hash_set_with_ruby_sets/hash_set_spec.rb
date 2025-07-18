# spec/hash_set_spec.rb
require 'rspec'
require_relative '../../lib/hash_set_with_ruby_sets/hash_set'

RSpec.describe HashSet do
  let(:set) { HashSet.new }

  describe 'initialization' do
    it 'sets default capacity and load factor' do
      expect(set.capacity).to eq(16)
      expect(set.load_factor).to eq(0.75)
    end

    it 'raises error if capacity is non-positive' do
      expect { HashSet.new(0) }.to raise_error(ArgumentError)
    end

    it 'raises error if load_factor is non-positive' do
      expect { HashSet.new(16, 0) }.to raise_error(ArgumentError)
    end
  end

  describe '#set and #get' do
    it 'stores and retrieves a key' do
      set.set('foo')
      expect(set.get('foo')).to eq('foo')
    end

    it 'returns nil for missing key' do
      expect(set.get('missing')).to be_nil
    end
  end

  describe '#has?' do
    it 'returns true for existing key' do
      set.set('bar')
      expect(set.has?('bar')).to be true
    end

    it 'returns false for non-existing key' do
      expect(set.has?('not-there')).to be false
    end
  end

  describe '#remove' do
    it 'removes an existing key' do
      set.set('x')
      set.remove('x')
      expect(set.get('x')).to be_nil
    end

    it 'does nothing if key does not exist' do
      expect { set.remove('ghost') }.not_to raise_error
    end
  end

  describe '#length' do
    it 'counts unique keys' do
      set.set('a')
      set.set('b')
      expect(set.length).to eq(2)
    end
  end

  describe '#clear' do
    it 'removes all keys' do
      set.set('a')
      set.set('b')
      set.clear
      expect(set.length).to eq(0)
    end
  end

  describe '#keys' do
    it 'returns all keys as an array' do
      set.set('k1')
      set.set('k2')
      expect(set.keys).to include('k1', 'k2')
    end
  end

  describe '#to_s' do
    it 'returns string representation' do
      set.set('hello')
      expect(set.to_s).to be_a(String)
    end
  end

  describe 'automatic resizing' do
    it 'doubles capacity when load factor exceeded' do
      s = HashSet.new(2, 0.5)
      2.times { |i| s.set("key#{i}") }
      expect(s.capacity).to be > 2
    end
  end
end
