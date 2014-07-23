class ChessBoard
	attr_reader :captures
	
	def initialize(board=nil,captures=nil)
		@board = board
		@captures = captures
		reset if board.nil?
	end
	
	def reset
		@board=
		(0..7).collect do |row|
			(0..7).collect do |column|
				if row.between?(2,5)
					nil
				else
					color=
					case row
					when 0,1 then :white
					else          :black
					end
					
					type=
					case row
					when 1,6 then :pawn
					else
						case column
						when 0, 7 then :rook
						when 1, 6 then :knight
						when 2, 5 then :bishop
						when 3    then :queen
						when 4    then :king
						end
					end
					
					[color,type]
				end
			end
		end
		
		@captures = []
	end
	
	def []((r,c))
		@board[r][c]
	end
	
	def move(source,destination)
		_assign(destination,self[source])
		clear(source)
	end
	
	def clear(position)
		_assign(position,nil)
	end
	
	def dup
		ChessBoard.new (0..7).collect do |row|
			(0..7).collect do |column|
				@board[row][column]
			end
		end
	end
	
	private
	
	def _assign((row,column),piece)
		@captures << @board[row][column] unless board[row][column].nil?
		@board[row][column] = piece
	end
end

module ChessCheckMixin
	
end