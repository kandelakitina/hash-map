# frozen_string_literal: true

# A node for keys only for a HashSet
class Node
  attr_accessor :key, :next_node

  def initialize(key = nil, next_node = nil)
    @key = key
    @next_node = next_node
  end
end
