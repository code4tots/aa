module Chess

class State
end

START = State.new
def START.[]( (r,c) )
	color =
		case r
		when 0, 1 then :white
		when 6, 7 then :black
		else           return nil
		end
	
	type =
		case r
		when 1, 6 then :pawn
		else#0, 7
			case c
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