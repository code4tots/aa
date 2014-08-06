class Board
  def initialize
    @board = Array.new(3) { Array.new(3) }
  end
  
  def won?
    return winner if winner != nil
    return :draw if @board.flatten.none? { |x| x.nil? }
  end
  
  def winner
    x = check_rows @board
    return x unless x.nil?
    x = check_rows @board.transpose
    return x unless x.nil?
    return check_diagonals @board
  end
  
  def empty?(pos)
    row, col = pos
    @board[row][col].nil?
  end
  
  def place_mark(pos,mark)
    row, col = pos
    @board[row][col] = mark
  end
  
  def to_s
    board_string = ""
    @board.each do |row|
      board_string += row.inspect
      board_string += "\n"
    end
    board_string
  end

  private
  def check_rows board
    (0...3).each do |row|
      return 'X' if board[row].uniq == ['X']
      return 'O' if board[row].uniq == ['O']
    end
    nil
  end
  
  def check_diagonals board
    middle = board[1][1]
    return middle if [board[0][0], board[2][2]].uniq == [middle]
    return middle if [board[2][0], board[0][2]].uniq == [middle]
    nil
  end
end

class Game
  attr_reader :board
  
  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @board = Board.new
  end
  
  def play
    @board = Board.new
    @player1.mark = 'X'
    @player2.mark = 'O'
    @current = @player1
    until @board.won?
      @current.make_move(@board)
      swap_players
    end
    
    if @board.won? == :draw
      puts @board
      puts "The game is drawn"
    else
      swap_players
      @current.declare_victory(@board)
    end
  end
  
  private
  
  def swap_players
    if @current == @player1
      @current = @player2
    else
      @current = @player1
    end
  end
  
end

class Player
  attr_accessor :mark
  
  def declare_victory(board)
    puts board
  end
end

class HumanPlayer < Player
  def make_move(board)
    puts board.to_s
    puts "make a move"
    print "input row    : "
    row = gets.to_i
    print "input column : "
    col = gets.to_i
    
    if (0...3).include?(row) && (0...3).include?(col) && board.empty?([row,col])
      board.place_mark([row,col],@mark)
    else
      puts "DON'T TRY TO CHEAT"
      make_move(board)
    end
  end
  
  def declare_victory(board)
    super(board)
    puts "You have won!!!"
  end
end

class ComputerPlayer < Player
  def make_move(board)
    until board.empty?([x = (0..2).to_a.sample, y = (0..2).to_a.sample])
    end
    board.place_mark([x,y], @mark)
  end
  
  def declare_victory(board)
    super(board)
    puts "Puny HUMAN YOU HAVE LOST!!!!"
  end
end

# game = Game.new(HumanPlayer.new, ComputerPlayer.new)
# game.play
game = Game.new(ComputerPlayer.new, ComputerPlayer.new)
while game.board.won? != :draw
  game = Game.new(ComputerPlayer.new, ComputerPlayer.new)
  game.play
end
# game = Game.new(HumanPlayer.new, HumanPlayer.new)
# game.play
