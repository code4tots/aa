require_relative 'tic_tac_toe_node'

class SuperComputerPlayer < ComputerPlayer
  
  def initialize
    super
    @name = "SUPER COMPUTA"
  end
  
  def move(game, mark)
    node = TicTacToeNode.new(game.board,mark)
    node.children.each do |child|
      return child.prev_move_pos if child.winning_node?(mark)
    end
    node.children.each do |child|
      return child.prev_move_pos unless child.losing_node?(mark)
    end
    raise "CHEATER -- I DID NOT PLAY THIS GAME"
  end
end

def super_match
  cp = SuperComputerPlayer.new
  cp_2 = ComputerPlayer.new
  ttt = TicTacToe.new(cp_2, cp)
  ttt.run
  ttt.board.winner
end



def test n
  record = Hash.new { 0 }
  total = 0
  n.times do |i|
    record[super_match] += 1
    STDERR.printf "O: %-4d - X:%-4d - Total:%-4d - Percent:(%f)\n", record[:o], record[:x], i+1, record[:o].to_f/(i+1)
  end
end

if __FILE__ == $PROGRAM_NAME
  test ARGV[0].to_i
end
