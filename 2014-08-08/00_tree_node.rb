class PolyTreeNode
  attr_reader :parent, :children
  attr_accessor :value
  
  def initialize(value)
    @parent = nil
    @children = []
    @value = value
  end
  
  def parent=(parent)
    @parent.children.delete(self) unless @parent.nil?
    parent.children << self unless parent.nil?
    @parent = parent
  end
  
  def add_child(child_node)
    child_node.parent = self
  end
  
  def remove_child(child)
    raise "FAIL" unless self == child.parent
    child.parent = nil
  end
  
  def dfs(value)
    return self if @value == value
    children.each do |child|
      result = child.dfs(value)
      return result unless result.nil?
    end
    nil
  end
  
  def bfs(value)
    queue = [self]
    until queue.empty?
      node = queue.shift
      return node if node.value == value
      queue.concat node.children
    end
    nil
  end
  
end

# n1 = PolyTreeNode.new("root1")
# n2 = PolyTreeNode.new("root2")
# n3 = PolyTreeNode.new("root3")
#
# # connect n3 to n1
# n3.parent = n1
# # connect n3 to n2
# n3.parent = n2
#
# # this should work
# raise "Bad parent=!" unless n3.parent == n2
# raise "Bad parent=!" unless n2.children == [n3]
#
# # this probably doesn't
# raise "Bad parent=!" unless n1.children == []

#               O
#     O      O     O     O
#   O  O   O  O  O  O  O  O
# 
