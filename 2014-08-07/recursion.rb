def range(start, end_)
  # once end reached return []
  return [] if end_ <= start
  # concatenate start num with subseq range
  # [start] + range(start+1,end_)
  range(start,end_-1) << [end_-1]
end

def recursive_array_sum(arr)
  return 0 if arr.size == 0
  arr[0] + recursive_array_sum(arr[1..-1])
end

def iterative_array_sum(arr)
  sum = 0
  arr.each do |element|
    sum += element
  end
  sum
end

def exp1(b, n)
  return 1 if n == 0
  b * exp1(b,n-1)
end

def exp2(b,n)
  return 1 if n == 0
  return b if n == 1
  if n.even?
    x = exp2(b, n/2)
    x * x
  else
    x = exp2(b, (n-1)/2)
    b * x * x
  end
end

#p exp1(2,10000)
# p exp2(2,10000)

# exp1(2,100) => exp1(2,99) => exp1(2,98) ... exp1(2,0)

# exp2(2,100) => exp2(2,50) => exp2(2,25) => exp2(2,12) =>

# robot_parts = [
#   ["nuts", "bolts", "washers"],
#   ["capacitors", "resistors", "inductors"]
# ]

## dup will make a reference/pointers to robo_parts
# robot_parts_copy = robot_parts.dup

class Array
  def deep_dup
    arr = []
    each do |el|
      if el.is_a? Array
        arr << el.deep_dup
      else
        arr << el
      end
    end
    arr
  end
end

# a = [1, [2], [3, [4]]]
# b = a.dup
# b[1][0] = 656
# p b # => [1, [656], [3, [4]]]
# p a # => [1, [656], [3, [4]]]
#
# a = [1, [2], [3, [4]]]
# b = a.deep_dup
# b[1][0] = 656
# p b # => [1, [656], [3, [4]]]
# p a # => [1, [2], [3, [4]]]

def fib(n)
  return [0, 1, 1][0...n] if n <= 3
  last = fib(n-1)
  last << last[-1] + last[-2]
end

def iterative_fib(n)
  return [0, 1, 1][0...n] if n <= 3
  fibs = [0, 1, 1]
  while fibs.size < n
    fibs << fibs[-1] + fibs[-2]
  end
  fibs
end

def binary_search(arr,target)
  return nil if arr.size == 0
  # Cut it in the middle to limit search criteria
  middle = arr.size / 2
  # arr[middle] reps the value of the middle element
  if target == arr[middle]
    arr[middle]
  elsif target < arr[middle]
    binary_search(arr[0...middle], target)
  else
    binary_search(arr[(middle+1)..-1], target)
  end
end
#
# a = (0...100).to_a.select(&:even?)
#
# p binary_search(a, 55)

def make_change(value,coins)
  return nil if value < coins.min
  best = nil
  coins.each do |coin|
    if value < coin
      next
    elsif value == coin
      return [coin]
    else
      # Try finding a combination of coins that will sum to value - coin.
      # Then you can get a combination of coins for value by adding the
      # current coin.
      candidate = [coin] + make_change(value - coin, coins)
    
      if candidate != nil && (best.nil? || candidate.size < best.size)
        best = [coin] + make_change(value - coin, coins)
      end
    end
    end
    best
end
# p make_change(14, [10, 7, 1])
# p make_change(17, [10, 7, 1])
# p make_change(10000, [1,2,4,5])
# p make_change(100, (1...10).to_a)

def merge_sort(arr)
  return arr if arr.size < 2
  middle = arr.size / 2
  # cut in half for sort selection
  arr1 = merge_sort(arr[0...middle])
  arr2 = merge_sort(arr[middle..-1])
  merge(arr1, arr2)
end

def merge(arr1, arr2)
  # create index i & j to track arr1 & arr2
  i = 0
  j = 0
  return_array = []
  
  # while there are still els in arr1 && arr2
  while i < arr1.size && j < arr2.size
    if arr1[i] < arr2[j]
      # push smaller value to array
      return_array << arr1[i]
      # move onto next arr[i] element
      i += 1
    else
      return_array << arr2[j]
      j+=1
    end
  end
  # return any elements that are left
  return_array += arr1[i..-1]
  return_array += arr2[j..-1]
  return_array
end
  


# 6 7 8 5 3

# 6 7 8
# 3 5
# p merge_sort([6,7,8,6,5,4, 99, 100, 43])

def subsets(arr)
  # return an empty array (tech a subset of an empty array) - base case
  return [[]] if arr.empty?
  # take out the last el
  last = arr[-1]
  # take all the other els
  # find all subsets don't have the last element
  subsets_without_last = subsets(arr[0...-1])
  # create an array with a combo of s (the el) & the last ele in arr
  # find all subsets that have the last element
  subsets_with_last = subsets_without_last.map { |s| s.dup << last }
  # merge with prior subsets
  # all subsets of arr either have the last element, or they don't.
  subsets_without_last + subsets_with_last
end


p subsets([]) # => [[]]
p subsets([1]) # => [[], [1]]
p subsets([1, 2]) # => [[], [1], [2], [1, 2]]
p subsets([1, 2, 3])
# => [[], [1], [2], [1, 2], [3], [1, 3], [2, 3], [1, 2, 3]]

# you can implement this as an Array method if you prefer.