require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos
  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    (0..2).flat_map do |row|
      (0..2).map do |col|
        if @board.empty? [row, col]
          new_board = @board.dup
          new_board[ [row,col] ] = @next_mover_mark
          child = TicTacToeNode.new(new_board,@next_mover_mark,[row,col])
          child.swap_mark
          child
        else
          nil
        end
      end
    end.compact
  end

  def losing_node?(evaluator)
    if @board.over?
      winner = @board.winner
      return !winner.nil? && winner != evaluator
    end
    
    if @next_mover_mark == evaluator
      children.all? { |child| child.losing_node?(evaluator) }
    else
      children.any? { |child| child.losing_node?(evaluator) }
    end
  end
  
  def winning_node?(evaluator)
    if @board.over?
      return @board.winner == evaluator
    end
    
    if @next_mover_mark == evaluator
      children.any? { |child| child.winning_node?(evaluator) }
    else
      children.all? { |child| child.winning_node?(evaluator) }
    end
  end
  
  def swap_mark
    if @next_mover_mark == :x
      @next_mover_mark = :o
    else
      @next_mover_mark = :x
    end
  end
end


# t = TicTacToeNode.new(Board.new,:x)
# t.children.map { |t| t.board.rows.each { |row| p row }; puts }
