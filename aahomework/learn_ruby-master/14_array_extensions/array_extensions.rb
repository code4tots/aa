class Array
  def sum
    inject(0){|total,x| total+x}
  end
  
  def square
    map {|x| x * x }
  end
  
  def square!
    map! {|x| x * x}
  end
end