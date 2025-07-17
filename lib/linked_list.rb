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

  def insert_or_update(key, value)
    existing_node = find_by_key(key)
    if existing_node
      existing_node.value = value
    else
      append(key, value)
    end
  end

  def append(key, value)
    node = Node.new(key, value)
    if empty?
      @head = node
    else
      @tail.next_node = node
    end
    @tail = node
    @size += 1
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
    return nil if index.negative? || index >= @size || empty?

    each_with_index do |node, i|
      return node if i == index
    end
  end

  # rubocop:disable Metrics/MethodLength
  def remove(node)
    return nil if empty? || node.nil?

    current_node = @head
    prev_node = nil

    if node == @head
      value = @head.value
      remove_head
      return value
    end

    while current_node
      if current_node == node
        prev_node.next_node = current_node.next_node
        @tail = prev_node if current_node == @tail
        @size -= 1
        return current_node.value
      end
      prev_node = current_node
      current_node = current_node.next_node
    end

    nil
  end
  # rubocop:enable Metrics/MethodLength

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

  def values
    map(&:value)
  end

  def entries
    flat_map { |item| [item.key, item.value] }
  end

  def remove_head
    @head = @head.next_node
    @tail = nil if @head.nil?
    @size -= 1
  end

  def empty?
    @head.nil?
  end
end
