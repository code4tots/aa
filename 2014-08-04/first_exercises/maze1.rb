require 'set'
ARGV[0] = 'maze.txt'

class Maze
  def maze_reader
    @maze = []
    File.open(ARGV[0]) do |file|
      file.readlines.each { |line| @maze << line.chomp.split('') }
    end
    self
  end
  
  def find_character char
    @maze.each_with_index do |y, yind|
      y.each_with_index do |x, xind|
        return [yind, xind] if x == char
      end
    end
  end
  
  def expand n
    r, c = n
    new_est = 1 + @est[[r,c]]
    @nodes.each do |(r2,c2)|
      if (r2-r).abs + (c2-c).abs == 1
        old_est = @est[[r2,c2]]
        if new_est < old_est
          @pre[[r2,c2]] = [r,c]
          @est[[r2,c2]] = new_est
        end
      end
    end
    @exp << [r,c]
  end
  
  def shortest_path
    @nrow = @maze.size
    @ncol = @maze[0].size
    @nodes = (0...@nrow).map do |row|
      (0...@ncol).map do |col|
        [row,col]
      end.reject{ |row, col| @maze[row][col] == '*' }
    end.flat_map{ |i| i }
    
    @start = find_character 'S'
    @end = find_character 'E'
    
    @est = { @start => 0 }
    @est.default = Float::INFINITY
    @pre = {}
    @exp = Set.new
    
    while !@exp.include?(@end)
      n = @end
      @nodes.each do |node|
        n = node if !@exp.include?(node) && @est[node] < @est[n]
      end
      expand(n)
    end
    
    if @est[@end] == Float::INFINITY
      @path = nil
      return nil
    end
    
    @path = [@end]
    while @pre.include?(@path[-1])
      @path << @pre[@path[-1]]
    end
    return @path.reverse!
  end
  
  def to_s
    if @path == nil
      puts "No path found"
      return nil
    end
    
    maze = []
    @maze.each {|row| maze << row.dup }
    
    @path.each do |row,col|
      maze[row][col] = 'X' unless ['S','E'].include?(maze[row][col])
    end
    
    maze.map { |row| row.map { |x| x.to_s }.join }.join "\n"
  end
  
end

m = Maze.new

m.maze_reader.shortest_path
puts m.to_s
