require 'gosu'

class ChessGui < Gosu::Window
	WIDTH  = 640
	HEIGHT = 640
	FULLSCREEN = false
	TITLE = 'chess'
	
	BLACK_SQUARE_COLOR = Gosu::Color.new(0xFF1EB1FA)
	WHITE_SQUARE_COLOR = Gosu::Color.new(0xFF1D4DB5)
	
	SQUARE_WIDTH  = WIDTH  / 8
	SQUARE_HEIGHT = HEIGHT / 8
	
	def initialize
		super WIDTH, HEIGHT, FULLSCREEN
		@model = ChessModel.new
		self.caption = TITLE
	end
	
	def draw_board
		(0..7).each do |row|
			(0..7).each do |column|
				color = (row+column).even? ?
					WHITE_SQUARE_COLOR : 
					BLACK_SQUARE_COLOR
				
				draw_quad(
					column     * SQUARE_WIDTH,
					(7-row)    * SQUARE_HEIGHT,
					color,
					
					(column+1) * SQUARE_WIDTH,
					(7-row)    * SQUARE_HEIGHT,
					color,
					
					column     * SQUARE_WIDTH,
					(8-row)    * SQUARE_HEIGHT,
					color,
					
					(column+1) * SQUARE_WIDTH,
					(8-row)    * SQUARE_HEIGHT,
					color)
			end
		end
	end
	
	def draw_pieces
		(0..7).each do |row|
			(0..7).each do |column|
			end
		end
	end
	
	def draw
		draw_board
	end
end

class ChessModel
	def initialize
	end
	
	def [] row, column
	end
end

ChessGui.new.show


