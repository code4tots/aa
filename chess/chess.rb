class Chess
	def initialize
		reset
	end
	
	def reset
		@move_history = []
		@board_history = []
		@flags_history = []
		@board = _starting_board
	end
	
	def []( (r,c) )
		@board[r][c]
	end
	
	def next_player
		@move_history.size % 2 == 0 ? :white : :black
	end
	
	def legal? move, flags={}
		from, to, promo = move
		
		# "Moving" to the same square does not count as a move.
		return false if from == to
		
		color, type = self[from]
		
		# The color of the piece that is being moved must belong
		# to the current player.
		return false unless color == next_player
		
		# TODO -- proper checking and flagging.
		# For now allow the moving of any single piece anywhere
		# on the board without any support for en passant, castling, or
		# pawn promotion.
		return true
	end
	
	def << move
		flags = Hash.new
		return if not legal?(move,flags)
		_simulate_move(move,flags)
	end
	
	# undo a simulated move.
	# Although publicly should be used just as an inverse to the
	# '<<' operator, internally it should work well paired with
	# '_simulate_move'
	def undo
		@board = @board_history.pop
		@move_history.pop
		@flags_history.pop
	end
	
	private
	
	def _starting_board
		(0..7).collect do |r|
			(0..7).collect do |c|
				case r
				when 2..5 then nil
				else
					color =
					case r
					when 0, 1 then :white
					else           :black
					end
					
					type =
					case r
					when 1, 6 then :pawn
					else
						case c
						when 0, 7 then :rook
						when 1, 6 then :knight
						when 2, 5 then :bishop
						when 3    then :queen
						when 4    then :king
						end
					end
					
					[color, type]
				end
			end
		end
	end
	
	def _clone_board
		(0..7).collect do |r|
			(0..7).collect do |c|
				@board[r][c]
			end
		end
	end
	
	# Simulates a move as described by move and the associated flags
	# without verifying the validity of the move or the flags.
	def _simulate_move move, flags
		# Archive the old board,
		# and make a clone to work on.
		@board_history << @board
		@board = _clone_board
		
		# Actually move the main piece
		_move_piece(from,to)
		
		# en passant is the only time in which a piece is captured that is
		# not on the destination square. As such, in this case, we must
		# clear out the square manually.
		_clear_square(flags[:en_passant]) if flags.include?(:en_passant)
		
		# Castling is the only time in which a player is allowed to move
		# two pieces on one turn. As such, this second movement must also
		# be handled manually.
		_move_piece(*flags[:castle]) if flags.include?(:castle)
		
		# Archive the move and the flags for that move.
		@move_history << move
		@flags_history << flags
	end
	
	def _move_piece( (fr,fc), (tr,tc))
		@board[tr][tc] = @board[fr][fc]
		@board[fr][fc] = nil
	end
	
	def _clear_square( (r,c) )
		@board[r][c] = nil
	end
end
