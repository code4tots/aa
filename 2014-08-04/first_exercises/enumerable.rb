def multiply_by_two arr
  arr.map{|i| i * 2}
end

class Array
  def my_each
    i = 0 
    while i < length
     yield(self[i])
     i += 1
    end
    self
  end
end

def median arr
  arr = arr.sort
  return arr[arr.size / 2] if arr.size.odd?
  (arr[arr.size/2] + arr[arr.size - 1]) / 2.0
end

def concat str_arr
  str_arr.inject("") {|x, total| x << total }
end


