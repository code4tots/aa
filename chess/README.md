Chess
=====

References:
	http://april.arc.us/post/88443951708/so-chess
	http://jenniferchen.io/post/88552199804/modularity-in-chess

Perusing through those blog posts it seems as though one of the assignments
early on is a chess program.

So this is my take at coding chess in ruby.


Plan is to first implement some sort of generic model that enforces the rules
of chess. Then I plan on reading some of those posts or code in more detail
for ideas on how I might want to implement the frontend.


----------------------------------------------------------------------------------

As it stands it doesn't really enforce the rules of chess, but may be used as a
dumb live chessboard.

	Click to select a piece,
	then click on another square to move the piece to that square.
	
	Press the 'r' key to reset the board.

