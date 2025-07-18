# frozen_string_literal: true

require_relative 'node'

class LinkedList
  include Enumerable

  attr_accessor :head, :tail, :size

  def initialize
    @head = nil
    @tail = nil
    @size = 0
  end

  def each
    current = @head
    while current
      yield current
      current = current.next_node
    end
  end

  def append(key)
    node = Node.new(key)
    if @head.nil?
      @head = node
    else
      @tail.next_node = node
    end
    @tail = node
    @size += 1
  end

  def insert_or_update(key)
    return if find_by_key(key)

    append(key)
  end

  def find_by_key(key)
    each do |node|
      return node if node.key == key
    end
    nil
  end

  def find_index(key = nil)
    each_with_index do |node, index|
      if block_given?
        return index if yield(node)
      elsif node.key == key
        return index
      end
    end
    nil
  end

  def contains?(item)
    !!find_by_key(item)
  end

  def at(index)
    index = @size + index if index.negative?
    return nil if index.negative? || index >= @size || @head.nil?

    each_with_index do |node, i|
      return node if i == index
    end
  end

  def remove_at(index)
    node = at(index)
    remove(node)
  end

  def remove_by_key(key)
    node = find_by_key(key)
    remove(node)
  end

  def keys
    map(&:key)
  end

  def to_s
    nodes = map { |node| "( #{node.key} )" }
    "#{nodes.join(' -> ')} -> nil"
  end

  private

  def remove_head
    @head = @head.next_node
    @tail = nil if @head.nil?
    @size -= 1
  end

  # rubocop:disable Metrics/MethodLength
  def remove(node)
    return nil if @head.nil? || node.nil?

    return remove_head if node == @head

    current_node = @head
    prev_node = nil

    while current_node
      if current_node == node
        prev_node.next_node = current_node.next_node
        @tail = prev_node if current_node == @tail
        @size -= 1
        return current_node.key
      end
      prev_node = current_node
      current_node = current_node.next_node
    end

    nil
  end
  # rubocop:enable Metrics/MethodLength
end
