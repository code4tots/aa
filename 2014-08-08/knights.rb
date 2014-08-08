require 'set'
require_relative 'tree_node'

class KnightPathFinder
  attr_reader :root
  
  def initialize start
    @start = start
    @visited_positions = Set.new
  end
  
  def build_move_tree
    @root = PolyTreeNode.new(@start)
    queue = [@root]
    @visited_positions = [@start].to_set
    until queue.empty?
      node = queue.shift
      new_move_positions(node.value).each do |position|
        new_node = PolyTreeNode.new(position)
        new_node.parent = node
        @visited_positions << new_node.value
        queue << new_node
      end
    end
  end
  
  def find_path(end_pos)
    @root.dfs(end_pos).trace_path_back
  end
  
  def new_move_positions(pos)
    self.class.valid_moves(pos).reject do |pos|
      @visited_positions.include?(pos)
    end
  end
  
  def self.valid_moves(pos)
    row, col = pos
    [1,-1].product([2,-2]).flat_map do |dr, dc|
      [ [row + dr, col + dc], [row + dc, col + dr] ]
    end.select { |pos| on_board?(pos) }
  end
  
  def self.on_board?(pos)
    pos.all? { |coordinate| (0..7).include?(coordinate) }
  end
end

kpf = KnightPathFinder.new([0,0])
kpf.build_move_tree
p kpf.find_path([6,2])
# kpf.root.print_tree

# 0 1
# 1 2

