extends FlowContainer

@export var Board_X_Size = 10
@export var Board_Y_Size = 10

@export var Tile_X_Size: int = 50
@export var Tile_Y_Size: int = 50

signal send_location

func _ready():
	# stop negative numbers from happening
	if Board_X_Size < 0 || Board_Y_Size < 0:
		return
	var Number_X = 0
	var Number_Y = 0
	# Set up the board
	var rng = RandomNumberGenerator.new()
	while Number_Y != Board_Y_Size:
		self.size.y += Tile_Y_Size + 5
		self.size.x += Tile_X_Size + 5
		while Number_X != Board_X_Size:
			var temp = Button.new()
			temp.set_custom_minimum_size(Vector2(Tile_X_Size, Tile_Y_Size))
			temp.connect("pressed", func():
				emit_signal("send_location", temp.name))
			temp.set_name(str(Number_X) + "-" + str(Number_Y))
			if( Number_Y > 1 && Number_Y < 8 && rng.randi_range(0, 4) == 0 ):
				var style = StyleBoxFlat.new()
				if(rng.randi_range(0, 1) == 0):
					style.bg_color = Color(1, 0, 0)
				else:
					style.bg_color = Color(0, 1, 0)  # Red color
				
				temp.add_theme_stylebox_override("normal", style)  # Correct function for adding StyleBox

			add_child(temp)
			Number_X += 1
		Number_Y += 1
		Number_X = 0
	Regular_Game()

func Regular_Game():
	get_node("1-0").add_child(Summon("Rook", 1))
	get_node("2-0").add_child(Summon("Knight", 1))
	get_node("3-0").add_child(Summon("Bishop", 1))
	get_node("4-0").add_child(Summon("Queen", 1))
	get_node("5-0").add_child(Summon("King", 1))
	get_node("6-0").add_child(Summon("Bishop", 1))
	get_node("7-0").add_child(Summon("Knight", 1))
	get_node("8-0").add_child(Summon("Rook", 1))
	
	get_node("1-1").add_child(Summon("Pawn", 1))
	get_node("2-1").add_child(Summon("Pawn", 1))
	get_node("3-1").add_child(Summon("Pawn", 1))
	get_node("4-1").add_child(Summon("Pawn", 1))
	get_node("5-1").add_child(Summon("Pawn", 1))
	get_node("6-1").add_child(Summon("Pawn", 1))
	get_node("7-1").add_child(Summon("Pawn", 1))
	get_node("8-1").add_child(Summon("Pawn", 1))
	
	get_node("1-9").add_child(Summon("Rook", 0))
	get_node("2-9").add_child(Summon("Knight", 0))
	get_node("3-9").add_child(Summon("Bishop", 0))
	get_node("4-9").add_child(Summon("Queen", 0))
	get_node("5-9").add_child(Summon("King", 0))
	get_node("6-9").add_child(Summon("Bishop", 0))
	get_node("7-9").add_child(Summon("Knight", 0))
	get_node("8-9").add_child(Summon("Rook", 0))
	
	get_node("1-8").add_child(Summon("Pawn", 0))
	get_node("2-8").add_child(Summon("Pawn", 0))
	get_node("3-8").add_child(Summon("Pawn", 0))
	get_node("4-8").add_child(Summon("Pawn", 0))
	get_node("5-8").add_child(Summon("Pawn", 0))
	get_node("6-8").add_child(Summon("Pawn", 0))
	get_node("7-8").add_child(Summon("Pawn", 0))
	get_node("8-8").add_child(Summon("Pawn", 0))

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
