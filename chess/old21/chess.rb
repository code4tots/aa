class Chess
	attr_reader :selection
	
	def initialize
		reset
	end
	
	def reset
		_reset_board
		@moves_history = []
		@flags_history = []
		@board_history = []
		@selection = nil
		self
	end
	
	def []((row,column))
		@board[row][column]
	end
	
	def legal?(move,flags={})
		# TODO
		# For now, allow all moves.
		# In the future, legal? should automatically populate the 'flags'
		# based on on 'from' and 'to'.
		true
	end
	
	def undo
		@board = @board_history.pop
		@flags_history.pop
		@moves_history.pop
	end
	
	def make_move(move,flags={})
		_simulate_move(move,flags) if legal?(move,flags)
	end
	
	def select(location)
		if @selection.nil?
			@selection = location
		else
			self.make_move [@selection,location]
			@selection = nil
		end
	end
	
	private
	
	def []=((row,column),piece)
		@board[row][column] = piece
	end
	
	def _reset_board
		@board = Array.new(8){Array.new(8)}
		[0,1,6,7].each do |row|
			color =
			case row
			when 0, 1 then :white
			else           :black
			end
			(0..7).each do |column|
				type =
				case row
				when 1, 6 then :pawn
				else
					case column
					when 0, 7 then :rook
					when 1, 6 then :knight
					when 2, 5 then :bishop
					when 3    then :queen
					when 4    then :king
					end
				end
				@board[row][column] = [color,type].freeze
			end
		end
	end
	
	def _move_piece_at(from,to)
		self[to] = self[from]
		self[from] = nil
	end
	
	def _capture_piece_at(location)
		self[location] = nil
	end
	
	def _clone_board
		@board = @board.collect {|row| row.dup}
	end
	
	def _simulate_move(move,flags)
		@moves_history << move
		@board_history << @board
		@flags_history << flags
		
		_clone_board
		
		from, to = move
		_move_piece_at(from,to)
		self[to] = flags[:promotion]          if flags.include?(:promotion)
		_move_piece_at(*flags[:castle])       if flags.include?(:castle)
		_capture_piece_at(flags[:en_passant]) if flags.include?(:en_passant)
	end
end

