class Array
  def two_sum
    (0...size).map do |x|
      ((x+1)...size).map do |y|
        [[x,y], self[x] + self[y]]
      end
    end.flat_map{|i|i}.select{|a,s| s == 0}.map{|a,s| a}
  end
end

p [1,2,-1].two_sum