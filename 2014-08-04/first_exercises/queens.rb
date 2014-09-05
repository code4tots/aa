class Queens

  def queen
    board = (0..7).flat_map do |y|
      (0..7).map do |x|
        [x,y]
      end
    end
  
    while true
      @working = board.sample(8) 
      break if checking
    end
    p @working.sort_by {|x, y| x}

  end

  def checking
  
    @working.each do |x, y|
      @working.each do |a, b|
        next if a == x || b == y
        return false if (x - a) == 0 || (y - b) == 0
        return false if (x - a).abs == (y - b).abs
      end
    end
    return true
  end

end
  

Queens.new.queen