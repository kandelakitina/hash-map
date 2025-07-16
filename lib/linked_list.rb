# frozen_string_literal: true

require_relative 'node'

# Linked-list class with many methods
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

  def append(value)
    node = Node.new(value)
    if empty?
      @head = node
    else
      @tail.next_node = node
    end
    @tail = node
    @size += 1
  end

  # def prepend(value)
  #   node = Node.new(value, @head)
  #   @tail = node if empty?
  #   @head = node
  #   @size += 1
  # end

  # def pop
  #   return nil if empty?
  # #   return clear_list if single_node?

  # #   @tail = at(-2)
  # #   @tail.next_node = nil
  # #   @size -= 1
  # end

  def find(value = nil, &block)
    if block_given?
      super(&block) # fallback to Enumerable#find
    else
      each_with_index do |node, index|
        return index if node.value == value
      end
      nil
    end
  end

  def contains?(item)
    !!find(item)
  end

  # def at(index)
  #   index = @size + index if index.negative?
  #   return nil if index.negative? || index >= @size || empty?

  #   each_with_index do |node, i|
  #     return node if i == index
  #   end
  # end

  # def insert_at(value, index)
  #   return prepend(value) if index.zero?
  #   return append(value) if index == @size

  #   prev_node = at(index - 1)
  #   current_node = prev_node.next_node
  #   prev_node.next_node = Node.new(value, current_node)
  #   @size += 1
  # end

  # def remove_at(index)
  #   return nil if empty?
  # #   return remove_head if index.zero?

  # #   prev_node = at(index - 1)
  # #   return nil if prev_node.nil? || prev_node.next_node.nil?

  #   current_node = prev_node.next_node
  #   prev_node.next_node = current_node.next_node
  #   @tail = prev_node if current_node == @tail
  #   @size -= 1
  # end

  # def to_s
  #   nodes = map { |node| "( #{node.value} )" }
  #   "#{nodes.join(' -> ')} -> nil"
  # end

  private

  def empty?
    @head.nil?
  end

  # def single_node?
  #   @head == @tail
  # end

  # def clear_list
  #   @head = nil
  #   @tail = nil
  #   @size = 0
  # end

  # def remove_head
  #   @head = @head.next_node
  #   @tail = nil if @head.nil?
  # end
end
