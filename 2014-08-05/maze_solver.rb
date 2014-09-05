class Maze
  def initialize(filename)
    @filename = filename
    @maze_array = create_maze_array(@filename)
    @maze_start = locate_character("S")
    @maze_end = locate_character("E")
    @current_position = []
  end
  
  attr_accessor :filename, :maze_array
  
  def create_maze_array(filename)
    maze_array = []
    File.open(filename).readlines.each do |line|
      maze_array << line.split('').to_a
    end
    maze_array
  end
  
  def locate_character(char)
    nrow = @maze_array.size
    ncol = @maze_array[0].size
    nrow.times do |row|
      ncol.times do |col|
        return [row, col] if @maze_array[row][col] == char
      end
    end     
  end
  
  def solve_maze
    @current_position = @maze_start
    
    while current_position != @maze_end
      
      
    end
    
    positional_log = []
    blocked_positions_log = []
    positional_log
  end
  
  def make_valid_move(position, log)
  
  
  
end

maze = Maze.new("maze.txt")
p maze.maze_array
p maze.locate_character("S")