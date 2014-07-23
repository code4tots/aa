require 'gosu'
require_relative 'chess'

class ChessGui < Gosu::Window
	LETTER_TABLE = Hash.new
	[:pawn,:rook,:bishop,:queen,:king].each {|s| LETTER_TABLE[s] = s[0].upcase}
	LETTER_TABLE[:knight] = 'N'
	
	COLOR_TABLE = {
		:white => 0xffffffff,
		:black => 0xff0003f0
	}
	
	BACKGROUND_COLOR_TABLE = {
		:white =>
	}
	
	def initialize
		super(640, 640, false)
		@model = Chess.new
		@font = Gosu::Font.new(self,Gosu::default_font_name, 640/8)
	end
	
	def draw
		#@font.draw("K", 0, 0, 0)
		(0..7).each do |r|
			(0..7).each do |c|
				color, type = @model[[r,c]]
				@font.draw(
					LETTER_TABLE[type],
					
					c*(640/8),
					(7-r)*(640/8),
					0,
					
					1,
					1,
					
					COLOR_TABLE[color]) unless type.nil?
			end
		end
	end
end

ChessGui.new.show if __FILE__ == $0
