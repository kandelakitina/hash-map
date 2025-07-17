# frozen_string_literal: true

require_relative 'lib/hash_map'

hash_map = HashMap.new
hash_map.set('k1', 'v1')
hash_map.set('k2', 'v2')

keys = hash_map.keys
p keys
