class Array
  
  def my_each
    i = 0
    while i < size
      yield self[i]
      i += 1
    end
  end
  
  def my_map
    return_arr = []
    my_each do |el|
      return_arr << (yield el)
    end
    return_arr
  end
  
  def my_select
    return_arr = []
    my_each do |el|
      # if yield el == select
      return_arr << el if (yield el)
    end
    return_arr
  end
  
  def my_inject
    # starting val
    sum = self[0]
    # perform my_each on subsequent vals
    self[1..-1].my_each do |el|
      # update sum with block passed to current val & el
      sum = (yield sum, el)
    end
    sum
  end
  
  def my_sort!
    (0...size).each do |i|
      ((i+1)...size).each do |j|
        if self[i] > self[j]
          self[i], self[j] = self[j], self[i]
        end
      end
    end
    self
  end
  
  def my_sort
    # copy, then sort 
    dup.my_sort!
  end
  
end

# a = (0..10).to_a.reverse
# b = [45, 60, 2, 39, 22, 100]

# b = a.my_map do |x|
#   x + 1
# end
# p b
#
# b = a.my_select do |x|
#   x.even?
# end
#
# p b

# b = a.my_inject do |sum, el|
#   sum + el
# end
#
# p b

# p b.my_sort

def eval_block(*args)
  if block_given? 
    yield *args
  else 
    puts "NO BLOCK GIVEN!" 
  end
end

eval_block("Kerry", "Washington", 23) do |fname, lname, score|
  puts "#{lname}, #{fname} won #{score} votes."
end


#Washington, Kerry won 23 votes.

#TODO ask about auto unsplat yield