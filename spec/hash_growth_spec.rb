# frozen_string_literal: true

require_relative '../lib/hash_map'
require_relative '../lib/linked_list'
require_relative '../lib/node'

RSpec.describe HashMap do
  let(:initial_capacity) { 4 }
  let(:load_factor) { 0.75 }
  let(:map) { described_class.new(initial_capacity, load_factor) }

  describe '#update_capacity' do
    it 'does not change capacity if load factor not exceeded' do
      map.set('a', 1)
      map.set('b', 2)

      expect { map.update_capacity }.not_to(change { map.capacity })
    end

    it 'doubles capacity if load factor is exceeded' do
      4.times { |i| map.set("key#{i}", i) }

      expect { map.update_capacity }.to change { map.capacity }.from(4).to(8)
    end

    it 'calls rehash with double capacity' do
      4.times { |i| map.set("k#{i}", i) }

      expect(map).to receive(:rehash).with(8)
      map.update_capacity
    end
  end

  describe '#rehash' do
    it 'replaces @buckets with a new array of increased capacity' do
      old_buckets = map.instance_variable_get(:@buckets)
      4.times { |i| map.set("item#{i}", i) }

      map.rehash(8)

      new_buckets = map.instance_variable_get(:@buckets)
      expect(new_buckets.length).to eq(8)
      expect(new_buckets).not_to eq(old_buckets)
    end

    it 'calls #append on each old bucket' do
      buckets = map.instance_variable_get(:@buckets)
      buckets.each { |b| b.insert_or_update('a', 1) } # fill each bucket with dummy data

      expect(map).to receive(:append).exactly(buckets.size).times
      map.rehash(8)
    end
  end

  describe '#append' do
    let(:bucket) { LinkedList.new }

    before do
      bucket.insert_or_update('x', 10)
      bucket.insert_or_update('y', 20)
    end

    it 'rehashes each key-value pair into the new bucket array' do
      map.rehash(8) # set up clean new buckets

      # Now test append
      expect do
        map.append(bucket)
      end.to change { map.length }.by(2)

      expect(map.get('x')).to eq(10)
      expect(map.get('y')).to eq(20)
    end
  end
end
