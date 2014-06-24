require 'gosu'

class ChessGui < Gosu::Window
	WINDOW_WIDTH = 640
	WINDOW_HEIGHT = 640
	
	FULLSCREEN = false
	
	SQUARE_WIDTH = WINDOW_WIDTH / 8
	SQUARE_HEIGHT = WINDOW_HEIGHT / 8
	
	LEFT_SQUARE_MARGIN = 15
	UPPER_SQUARE_MARGIN = 5
	
	BOARD_COLOR_TABLE = {
		:white => 0xBF1EB1FA,
		:black => 0xBF1D4DB5,
		:highlight => 0xBFFFFF00
	}
	
	CHESSPIECE_LETTER_TABLE = {
		:pawn => 'P',
		:rook => 'R',
		:knight => 'N',
		:bishop => 'B',
		:queen => 'Q',
		:king => 'K'
	}
	
	CHESSPIECE_COLOR_TABLE = {
		:white => 0xFF000000,
		:black => 0xFFFFFFFF
	}
	
	def initialize
		super WINDOW_WIDTH, WINDOW_HEIGHT, FULLSCREEN
		@model = ChessModel.new
		@font = Gosu::Font.new(self, Gosu::default_font_name, 75)
	end
	
	def needs_cursor?
		true
	end
	
	def draw
		draw_chessboard
		draw_chesspieces
	end
	
	def draw_chessboard
		(0..7).each do |row|
			(0..7).each do |column|
				color = @model.selected?(row,column) ?
					:highlight :
					(row+column).even? ? :black : :white
				
				draw_chessboard_square(row,column,color)
			end
		end
	end
	
	def draw_chessboard_square row, column, color
		color = BOARD_COLOR_TABLE[color]
		
		x_lower = SQUARE_WIDTH * column
		x_upper = x_lower + SQUARE_WIDTH
		y_lower = SQUARE_HEIGHT * (7-row)
		y_upper = y_lower + SQUARE_HEIGHT
		
		draw_quad(
			x_lower,y_lower,color,
			x_lower,y_upper,color,
			x_upper,y_lower,color,
			x_upper,y_upper,color)
	end
	
	def draw_chesspieces
		(0..7).each do |row|
			(0..7).each do |column|
				color, type = @model[row,column]
				
				unless type.nil?
					draw_chesspiece row, column, color, type
				end
			end
		end
	end
	
	def draw_chesspiece row, column, color, type
		color = CHESSPIECE_COLOR_TABLE[color]
		letter = CHESSPIECE_LETTER_TABLE[type]
		
		x_lower = SQUARE_WIDTH * column + LEFT_SQUARE_MARGIN
		y_lower = SQUARE_HEIGHT * (7-row) + UPPER_SQUARE_MARGIN
		
		@font.draw(letter, x_lower, y_lower, 0, 1, 1, color)
	end
	
	def button_down id
		case id
		when Gosu::MsLeft
			row = 7-(self.mouse_y/SQUARE_HEIGHT).to_i
			column = (self.mouse_x/SQUARE_WIDTH).to_i
			
			@model.click(row,column)
		when Gosu::KbR
			@model.reset
		end
	end
end

class ChessModel
	attr_reader :selected
	
	def initialize
		reset
	end
	
	def reset
		setup_board
		reset_click
		@next_player = :white
	end
	
	def setup_board
		@board = (0..7).collect do |row|
			(0..7).collect do |column|
				case row
				when 2..5 then nil
				else
					color =
					case row
					when 0, 1 then :white
					else           :black
					end
					
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
					
					[color,type]
				end
			end
		end
	end
	
	def [] row, column
		@board[row][column]
	end
	
	def click row, column
		if @selected.nil?
			@selected = [row,column] unless @board[row][column].nil?
		else
			old_row, old_column = @selected
			piece = @board[old_row][old_column]
			@board[old_row][old_column] = nil
			@board[row][column] = piece
			@selected = nil
		end
	end
	
	def reset_click
		@selected = nil
	end
	
	def selected? row, column
		@selected == [row,column]
	end
end


ChessGui.new.show if __FILE__ == $0


