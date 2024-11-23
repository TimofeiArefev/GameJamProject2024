extends Node
@export var Tile_X_Size: int = 50
@export var Tile_Y_Size: int = 50
# Define global colors
var bomb = Color(1, 0, 0)
var jump = Color(1, 1, 0)
var dup  = Color(0, 1, 0)
var fakedup  = Color(1, 1, 1)

var teleport = Color(0, 0, 1)
var teleport_rand = Color(0.68, 0.85, 0.90)

var teleport_positions = []


func Summon(Piece_Name: String, color: int):
	var Piece
	match Piece_Name:
		"Pawn":
			Piece = Pawn.new()
			Piece.name = "Pawn"
		"King":
			Piece = King.new()
			Piece.name = "King"
		"Queen":
			Piece = Queen.new()
			Piece.name = "Queen"
		"Knight":
			Piece = Knight.new()
			Piece.name = "Knight"
		"Rook":
			Piece = Rook.new()
			Piece.name = "Rook"
		"Bishop":
			Piece = Bishop.new()
			Piece.name = "Bishop"
	Piece.Item_Color = color
	Piece.position = Vector2(Tile_X_Size / 2, Tile_Y_Size / 2)
	return Piece
