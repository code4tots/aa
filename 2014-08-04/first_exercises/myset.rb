class MyHashSet
  
  def initialize()
   @store = {}  
  end
  
  def insert el
    @store[el] = true
  end
  
  def include? el
    @store[el] ? true : false
  end
  
  def delete el
    x = @store.include?(el)
    @store.delete(el)
    x
  end
  
  def to_a
    @store.keys.to_a
  end
  
  def union set2
    return_set = MyHashSet.new
    to_a.each do |x|
      return_set.insert(x)
    end
    
    set2.to_a.each do |y|
      return_set.insert(y)
    end
    
    return_set
  end
  
  def intersect set2
    return_set = MyHashSet.new
    to_a.each do |x|
      set2.to_a.each do |y|
        return_set.insert(x) if x == y
      end
    end
    return_set
  end
  
  def minus set2
    s = MyHashSet.new
    to_a.each {|x| s.insert(x) }
    set2.to_a.each {|x|s.delete(x) }
    s
  end
end

a = MyHashSet.new
b = MyHashSet.new

(0..12).each {|i| a.insert(i) }
(6..17).each {|i| b.insert(i) }
p(a.union(b))
p(a.intersect(b))
p(a.minus(b))

