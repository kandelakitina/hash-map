# spec/linked_list_spec.rb
# frozen_string_literal: true

require_relative '../lib/linked_list'
require_relative '../lib/node'

RSpec.describe LinkedList do
  let(:list) { LinkedList.new }

  describe '#initialize' do
    it 'initializes an empty list' do
      expect(list.head).to be_nil
      expect(list.tail).to be_nil
      expect(list.size).to eq(0)
      expect(list.empty?).to be true
    end
  end

  describe '#append' do
    it 'adds a node to the empty list' do
      list.append(:foo, 'bar')
      expect(list.head.key).to eq(:foo)
      expect(list.head.value).to eq('bar')
      expect(list.tail).to eq(list.head)
      expect(list.size).to eq(1)
    end

    it 'adds multiple nodes in order' do
      list.append(:a, 1)
      list.append(:b, 2)
      list.append(:c, 3)

      expect(list.size).to eq(3)
      expect(list.head.key).to eq(:a)
      expect(list.tail.key).to eq(:c)
    end
  end

  describe '#insert_or_update' do
    it 'inserts if key does not exist' do
      list.insert_or_update(:x, 42)
      expect(list.find_by_key(:x).value).to eq(42)
    end

    it 'updates if key exists' do
      list.append(:x, 1)
      list.insert_or_update(:x, 99)
      expect(list.find_by_key(:x).value).to eq(99)
      expect(list.size).to eq(1)
    end
  end

  describe '#find_by_key' do
    before do
      list.append(:x, 'x_val')
      list.append(:y, 'y_val')
    end

    it 'finds a node by key' do
      node = list.find_by_key(:y)
      expect(node).not_to be_nil
      expect(node.key).to eq(:y)
    end

    it 'returns nil if key is not found' do
      expect(list.find_by_key(:z)).to be_nil
    end

    it 'can use a block with Enumerable#find' do
      node = list.find { |n| n.key == :y }
      expect(node.value).to eq('y_val')
    end
  end

  describe '#find_index' do
    before do
      list.append(:a, 10)
      list.append(:b, 20)
    end

    it 'returns the correct index for a key' do
      expect(list.find_index(:b)).to eq(1)
    end

    it 'returns nil if key not found' do
      expect(list.find_index(:z)).to be_nil
    end

    it 'works with block form' do
      expect(list.find_index { |n| n.key == :a }).to eq(0)
    end
  end

  describe '#contains?' do
    it 'returns true if key exists' do
      list.append(:key, 'val')
      expect(list.contains?(:key)).to be true
    end

    it 'returns false if key does not exist' do
      expect(list.contains?(:missing)).to be false
    end
  end

  describe '#at' do
    before do
      list.append(:first, 1)
      list.append(:second, 2)
      list.append(:third, 3)
    end

    it 'returns node at given index' do
      expect(list.at(1).key).to eq(:second)
    end

    it 'supports negative index' do
      expect(list.at(-1).key).to eq(:third)
      expect(list.at(-2).key).to eq(:second)
    end

    it 'returns nil if index is out of bounds' do
      expect(list.at(100)).to be_nil
      expect(list.at(-100)).to be_nil
    end
  end

  describe '#remove_at' do
    before do
      list.append(:a, 1)
      list.append(:b, 2)
      list.append(:c, 3)
    end

    it 'removes head node' do
      list.remove_at(0)
      expect(list.head.key).to eq(:b)
      expect(list.size).to eq(2)
    end

    it 'removes tail node' do
      list.remove_at(2)
      expect(list.tail.key).to eq(:b)
      expect(list.size).to eq(2)
    end

    it 'removes middle node' do
      list.remove_at(1)
      expect(list.head.next_node.key).to eq(:c)
      expect(list.size).to eq(2)
    end

    it 'returns nil if index invalid' do
      expect(list.remove_at(100)).to be_nil
    end
  end

  describe '#each' do
    it 'yields all nodes in order' do
      list.append(:a, 1)
      list.append(:b, 2)

      keys = []
      list.each { |n| keys << n.key }

      expect(keys).to eq(%i[a b])
    end
  end

  describe '#empty?' do
    it 'returns true if list is empty' do
      expect(list.empty?).to be true
    end

    it 'returns false if list has nodes' do
      list.append(:x, 5)
      expect(list.empty?).to be false
    end
  end
end
