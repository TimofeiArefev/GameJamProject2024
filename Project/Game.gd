extends Control

var Selected_Node = ""
var Turn = 0

var Location_X = ""
var Location_Y = ""

var pos = Vector2(25, 25)
var Areas: PackedStringArray
# this is seperate the Areas for special circumstances, like castling.
var Special_Area: PackedStringArray

func add_text_at_position(text: String, position: Vector2):
	get_node("TextContainer").remove_child(get_node("TextContainer").get_child(0))
	
	var label = Label.new()
	
	label.add_theme_font_size_override("font_size", 24)  # Sets the font size to 24

	label.text = text
	label.position = position
	get_node("TextContainer").add_child(label)



func is_double_jump_square(x, y):
	var style = get_node("Flow/" + str(x) + "-" + str(y)).get_theme_stylebox("normal")
	if style is StyleBoxFlat:
		var color = style.bg_color
		if(color == Globals.jump):
			return true
	return false
	
func is_duplicate_square(x, y):
	var style = get_node("Flow/" + str(x) + "-" + str(y)).get_theme_stylebox("normal")
	if style is StyleBoxFlat:
		var color = style.bg_color
		if(color == Globals.dup ):
			return true
	return false
	
func is_boomb_square(x, y):
	var style = get_node("Flow/" + str(x) + "-" + str(y) ).get_theme_stylebox("normal")
	if style is StyleBoxFlat:
		var color = style.bg_color
		if(color == Globals.bomb):
			return true
	return false
	
var position_x = 650
var position_y = 70

func duoble_jump_square(node, pos, Piece, diraction):
	var piece_position = node.get_name().split('-')
	piece_position[1] = str(int(piece_position[1]) + diraction)
	piece_position = piece_position[0] + '-' + piece_position[1]
	var node2 = get_node("Flow/" + piece_position)
	if (node2.get_child_count() != 0):
		Piece.reparent(node)
		Piece.position = pos
		Update_Game(node)
	else:
		Piece.reparent(node2)
		Piece.position = pos
		Update_Game(node2)
	
	print("Text should be added")
	add_text_at_position("Double jump", Vector2(position_x, position_y))

		
func is_teleport_square(x, y):
	var style = get_node("Flow/" + str(x) + "-" + str(y)).get_theme_stylebox("normal")
	if style is StyleBoxFlat:
		var color = style.bg_color
		if(color == Globals.teleport):
			return true
	return false
	
func find_teleport_square(node, xb, yb, Piece):
	var piece_position = node.get_name().split('-')
	for x in range(10):
		for y in range(10):
			var style = get_node("Flow/" + str(x) + "-" + str(y)).get_theme_stylebox("normal")
			if style is StyleBoxFlat:
				var color = style.bg_color
				if(color == Globals.teleport):
					if x != int(xb) && y != int(yb):
						piece_position = str(x) + '-' + str(y)
						var node2 = get_node('Flow/' + piece_position)
						if node2.get_child_count() == 0:
							Piece.reparent(node2)
							Piece.position = pos
							Update_Game(node2)
						else:
							Piece.reparent(node)
							Piece.position = pos
							Update_Game(node)
							


		
func duplicate_square(node, pos, Piece):
	print("Duplicate")
	var piece_position = node.get_name().split('-')
	piece_position[1] = str(int(piece_position[1]) )
	piece_position = piece_position[0] + '-' + piece_position[1]
	var style = StyleBoxFlat.new()
	
	style.bg_color = Color(0.1, 0.1, 0.1, 0.6)  # Red color
	print("Node: ", node)
	node.add_theme_stylebox_override("normal", style)
	var node2 = get_node("Flow/" + piece_position)
	node2.add_theme_stylebox_override("normal", style)
	if (node2.get_child_count() != 0):
		node.add_child(Piece.duplicate())
		Piece.position = pos
		Update_Game(node)
	elif Piece:
		node2.add_child(Piece.duplicate())
		Piece.position = pos
		Update_Game(node2)
	add_text_at_position("Duplicate", Vector2(position_x, position_y))
		

func check_coords(x, y):
	# Define the potential directions
	var directions = [
		Vector2(-1, 0),  # Up
		Vector2(1, 0),   # Down
		Vector2(0, -1),  # Left
		Vector2(0, 1),   # Right
		Vector2(-1, -1), # Top-left
		Vector2(-1, 1),  # Top-right
		Vector2(1, -1),  # Bottom-left
		Vector2(1, 1)    # Bottom-right
	]
	
	# Define the grid size
	var grid_size = 10
	
	# List to hold valid coordinates
	var valid_coords = []
	
	# Check each direction
	for dir in directions:
		var new_x = x + dir.x
		var new_y = y + dir.y
		if new_x >= 0 and new_x < grid_size and new_y >= 0 and new_y < grid_size:
			valid_coords.append(Vector2(new_x, new_y))
	
	return valid_coords




func boomb_square(node, pos, Piece):
	# Extract the current position from the node's name
	var piece_position = node.get_name().split('-')
	var current_x = int(piece_position[0])
	var current_y = int(piece_position[1])
	
	# Get valid adjacent coordinates
	var adjacent_coords = check_coords(current_x, current_y)
	
	Piece.reparent(node)
	Piece.position = pos
	Update_Game(node)
	var style = StyleBoxFlat.new()
	
	style.bg_color = Color(0.1, 0.1, 0.1, 0.6)  # Red color
	print("Node: ", node)
	node.add_theme_stylebox_override("normal", style)
	# Iterate over each adjacent coordinate
	for coord in adjacent_coords:
		var coord_x = int(coord.x)
		var coord_y = int(coord.y)
		var coord_name = str(coord_x) + "-" + str(coord_y)
		
		# Retrieve the node at the adjacent coordinate
		var adjacent_node = get_node("Flow/" + coord_name)
		## Check if the adjacent node has children (i.e., a piece is present)
		if adjacent_node.get_child_count() > 0:
			# Remove the piece from the adjacent node
			adjacent_node.get_child(0).queue_free()
			

	# Update the game state
	#Update_Game(node)

func _on_flow_send_location(location: String):
	# variables for later
	var number = 0
	Location_X = ""
	var node = get_node("Flow/" + location)
	# This is to try and grab the X and Y coordinates from the board
	while location.substr(number, 1) != "-":
		Location_X += location.substr(number, 1)
		number += 1
	Location_Y = location.substr(number + 1)
	# Now... we need to figure out how to select the pieces. If there is a valid move, do stuff.
	# If we re-select, just go to that other piece
	if Selected_Node == "" && node.get_child_count() != 0 && node.get_child(0).Item_Color == Turn:
		Selected_Node = location
		Get_Moveable_Areas()
	elif Selected_Node != "" && node.get_child_count() != 0 && node.get_child(0).Item_Color == Turn && node.get_child(0).name == "Rook":
		# Castling
		for i in Areas:
			if i == node.name:
				var king = get_node("Flow/" + Selected_Node).get_child(0)
				var rook = node.get_child(0)
				# Using a seperate array because Areas wouldn't be really consistant...
				king.reparent(get_node("Flow/" + Special_Area[1]))
				rook.reparent(get_node("Flow/" + Special_Area[0]))
				king.position = pos
				rook.position = pos
				# We have to get the parent because it will break lmao.
				Update_Game(king.get_parent())
	# En Passant
	elif Selected_Node != "" && node.get_child_count() != 0 && node.get_child(0).Item_Color != Turn && node.get_child(0).name == "Pawn" && Special_Area.size() != 0 && Special_Area[0] == node.name && node.get_child(0).get("En_Passant") == true:
		for i in Special_Area:
			if i == node.name:
				var pawn = get_node("Flow/" + Selected_Node).get_child(0)
				node.get_child(0).free()
				pawn.reparent(get_node("Flow/" + Special_Area[1]))
				pawn.position = pos
				Update_Game(pawn.get_parent())
	elif Selected_Node != "" && node.get_child_count() != 0 && node.get_child(0).Item_Color == Turn:
		# Re-select
		Selected_Node = location
		Get_Moveable_Areas()
	elif Selected_Node != "" && node.get_child_count() != 0 && node.get_child(0).Item_Color != Turn:
		# Taking over a piece
		for i in Areas:
			if i == node.name:
				var Piece = get_node("Flow/" + Selected_Node).get_child(0)
				# Win conditions
				
				if node.get_child(0).name == "King":
					print("Damn, you win!")
				
				node.get_child(0).free()
				if(is_double_jump_square(Location_X, Location_Y)):
					duoble_jump_square(node, pos, Piece, 1 if Piece.Item_Color else -1)
				elif(is_duplicate_square(Location_X, Location_Y)):
					duplicate_square(node, pos, Piece)
				elif (is_teleport_square(Location_X, Location_Y)):
					find_teleport_square(node, Location_X, Location_Y, Piece)
				else:
					Piece.reparent(node)
					Piece.position = pos
					Update_Game(node)
	elif Selected_Node != "" && node.get_child_count() == 0:
		# Moving a piece
		for i in Areas:
			if i == node.name:
				var Piece = get_node("Flow/" + Selected_Node).get_child(0)
				var style = get_node("Flow/" + str(Location_X) + "-" + str(Location_Y) ).get_theme_stylebox("normal")
				print(style.bg_color)
				# Check if it's a StyleB

				if(is_double_jump_square(Location_X, Location_Y)):
					duoble_jump_square(node, pos, Piece, 1 if Piece.Item_Color else -1)
					
				elif (is_duplicate_square(Location_X, Location_Y)):
					duplicate_square(node, pos, Piece )
				elif(is_boomb_square(Location_X, Location_Y)):
					print("I have a boomb")
					boomb_square(node, pos, Piece)
				elif (is_teleport_square(Location_X, Location_Y)):
					find_teleport_square(node, Location_X, Location_Y, Piece)
				elif Piece:
					Piece.reparent(node)
					Piece.position = pos
					Update_Game(node)

func Update_Game(node):
	Selected_Node = ""
	if Turn == 0:
		Turn = 1
	else:
		Turn = 0
	
	# get the en-passantable pieces and undo them
	var things = get_node("Flow").get_children()
	for i in things:
		if i.get_child_count() != 0 && i.get_child(0).name == "Pawn" && i.get_child(0).Item_Color == Turn && i.get_child(0).En_Passant == true:
			i.get_child(0).set("En_Passant", false)
	
	# Remove the abilities once they are either used or not used
	if node.get_child(0).name == "Pawn":
		if node.get_child(0).Double_Start == true:
			node.get_child(0).En_Passant = true
		node.get_child(0).Double_Start = false
	if node.get_child(0).name == "King":
		node.get_child(0).Castling = false
	if node.get_child(0).name == "Rook":
		node.get_child(0).Castling = false

# Below is the movement that is used for the pieces
func Get_Moveable_Areas():
	var Flow = get_node("Flow")
	# Clearing the arrays
	Areas.clear()
	Special_Area.clear()
	var Piece = get_node("Flow/" + Selected_Node).get_child(0)
	# For the selected piece that we have, we can get the movement that we need here.
	if Piece.name == "Pawn":
		Get_Pawn(Piece, Flow)
	elif Piece.name == "Bishop":
		Get_Diagonals(Flow)
	elif Piece.name == "King":
		Get_Around(Piece)
	elif Piece.name == "Queen":
		Get_Diagonals(Flow)
		Get_Rows(Flow)
	elif Piece.name == "Rook":
		Get_Rows(Flow)
	elif Piece.name == "Knight":
		Get_Horse()

func Get_Pawn(Piece, Flow):
	# This is for going from the bottom to the top, also known as the white pawns.
	if Piece.Item_Color == 0:
		if not Is_Null(Location_X + "-" + str(int(Location_Y) - 1)) && Flow.get_node(Location_X + "-" + str(int(Location_Y) - 1)).get_child_count() == 0:
			Areas.append(Location_X + "-" + str(int(Location_Y) - 1))
		if not Is_Null(Location_X + "-" + str(int(Location_Y) - 2)) && Piece.Double_Start == true && Flow.get_node(Location_X + "-" + str(int(Location_Y) - 2)).get_child_count() == 0:
			Areas.append(Location_X + "-" + str(int(Location_Y) - 2))
		# Attacking squares
		if not Is_Null(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1)) && Flow.get_node(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1)).get_child_count() == 1:
			Areas.append(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1))
		if not Is_Null(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1)) && Flow.get_node(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1)).get_child_count() == 1:
			Areas.append(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1))
		# En passant
		if not Is_Null(str(int(Location_X) - 1) + "-" + Location_Y) && not Is_Null(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1)):
			if Flow.get_node(str(int(Location_X) - 1) + "-" + Location_Y).get_child_count() == 1 && Flow.get_node(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1)).get_child_count() != 1:
				Special_Area.append(str(int(Location_X) - 1) + "-" + Location_Y)
				Special_Area.append(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1))
		if not Is_Null(str(int(Location_X) + 1) + "-" + Location_Y) && not Is_Null(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1)):
			if Flow.get_node(str(int(Location_X) + 1) + "-" + Location_Y).get_child_count() == 1 && Flow.get_node(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1)).get_child_count() != 1:
				Special_Area.append(str(int(Location_X) + 1) + "-" + Location_Y)
				Special_Area.append(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1))
	# Black pawns
	else:
		if not Is_Null(Location_X + "-" + str(int(Location_Y) + 1)) && Flow.get_node(Location_X + "-" + str(int(Location_Y) + 1)).get_child_count() == 0:
			Areas.append(Location_X + "-" + str(int(Location_Y) + 1))
		if not Is_Null(Location_X + "-" + str(int(Location_Y) + 2)) && Piece.Double_Start == true && Flow.get_node(Location_X + "-" + str(int(Location_Y) + 2)).get_child_count() == 0:
			Areas.append(Location_X + "-" + str(int(Location_Y) + 2))
		# Attacking squares
		if not Is_Null(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1)) && Flow.get_node(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1)).get_child_count() == 1:
			Areas.append(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1))
		if not Is_Null(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1)) && Flow.get_node(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1)).get_child_count() == 1:
			Areas.append(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1))
		if not Is_Null(str(int(Location_X) - 1) + "-" + Location_Y) && not Is_Null(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1)):
			if Flow.get_node(str(int(Location_X) - 1) + "-" + Location_Y).get_child_count() == 1 && Flow.get_node(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1)).get_child_count() != 1:
				Special_Area.append(str(int(Location_X) - 1) + "-" + Location_Y)
				Special_Area.append(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1))
		if not Is_Null(str(int(Location_X) + 1) + "-" + Location_Y) && not Is_Null(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1)):
			if Flow.get_node(str(int(Location_X) + 1) + "-" + Location_Y).get_child_count() == 1 && Flow.get_node(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1)).get_child_count() != 1:
				Special_Area.append(str(int(Location_X) + 1) + "-" + Location_Y)
				Special_Area.append(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1))

func Get_Around(Piece):
	# Single Rows
	if not Is_Null(Location_X + "-" + str(int(Location_Y) + 1)):
		Areas.append(Location_X + "-" + str(int(Location_Y) + 1))
	if not Is_Null(Location_X + "-" + str(int(Location_Y) - 1)):
		Areas.append(Location_X + "-" + str(int(Location_Y) - 1))
	if not Is_Null(str(int(Location_X) + 1) + "-" + Location_Y):
		Areas.append(str(int(Location_X) + 1) + "-" + Location_Y)
	if not Is_Null(str(int(Location_X) - 1) + "-" + Location_Y):
		Areas.append(str(int(Location_X) - 1) + "-" + Location_Y)
	# Diagonal
	if not Is_Null(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1)):
		Areas.append(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1))
	if not Is_Null(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1)):
		Areas.append(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1))
	if not Is_Null(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1)):
		Areas.append(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1))
	if not Is_Null(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1)):
		Areas.append(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1))
	# Castling, if that is the case
	if Piece.Castling == true:
		Castle()

func Get_Rows(Flow):
	var Add_X = 1
	# Getting the horizontal rows first.
	while not Is_Null(str(int(Location_X) + Add_X) + "-" + Location_Y):
		Areas.append(str(int(Location_X) + Add_X) + "-" + Location_Y)
		if Flow.get_node(str(int(Location_X) + Add_X) + "-" + Location_Y).get_child_count() != 0:
			break
		Add_X += 1
	Add_X = 1
	while not Is_Null(str(int(Location_X) - Add_X) + "-" + Location_Y):
		Areas.append(str(int(Location_X) - Add_X) + "-" + Location_Y)
		if Flow.get_node(str(int(Location_X) - Add_X) + "-" + Location_Y).get_child_count() != 0:
			break
		Add_X += 1
	var Add_Y = 1
	# Now we are getting the vertical rows.
	while not Is_Null(Location_X + "-" + str(int(Location_Y) + Add_Y)):
		Areas.append(Location_X + "-" + str(int(Location_Y) + Add_Y))
		if Flow.get_node(Location_X + "-" + str(int(Location_Y) + Add_Y)).get_child_count() != 0:
			break
		Add_Y += 1
	Add_Y = 1
	while not Is_Null(Location_X + "-" + str(int(Location_Y) - Add_Y)):
		Areas.append(Location_X + "-" + str(int(Location_Y) - Add_Y))
		if Flow.get_node(Location_X + "-" + str(int(Location_Y) - Add_Y)).get_child_count() != 0:
			break
		Add_Y += 1
	
func Get_Diagonals(Flow):
	var Add_X = 1
	var Add_Y = 1
	while not Is_Null(str(int(Location_X) + Add_X) + "-" + str(int(Location_Y) + Add_Y)):
		Areas.append(str(int(Location_X) + Add_X) + "-" + str(int(Location_Y) + Add_Y))
		if Flow.get_node(str(int(Location_X) + Add_X) + "-" + str(int(Location_Y) + Add_Y)).get_child_count() != 0:
			break
		Add_X += 1
		Add_Y += 1
	Add_X = 1
	Add_Y = 1
	while not Is_Null(str(int(Location_X) - Add_X) + "-" + str(int(Location_Y) + Add_Y)):
		Areas.append(str(int(Location_X) - Add_X) + "-" + str(int(Location_Y) + Add_Y))
		if Flow.get_node(str(int(Location_X) - Add_X) + "-" + str(int(Location_Y) + Add_Y)).get_child_count() != 0:
			break
		Add_X += 1
		Add_Y += 1
	Add_X = 1
	Add_Y = 1
	while not Is_Null(str(int(Location_X) + Add_X) + "-" + str(int(Location_Y) - Add_Y)):
		Areas.append(str(int(Location_X) + Add_X) + "-" + str(int(Location_Y) - Add_Y))
		if Flow.get_node(str(int(Location_X) + Add_X) + "-" + str(int(Location_Y) - Add_Y)).get_child_count() != 0:
			break
		Add_X += 1
		Add_Y += 1
	Add_X = 1
	Add_Y = 1
	while not Is_Null(str(int(Location_X) - Add_X) + "-" + str(int(Location_Y) - Add_Y)):
		Areas.append(str(int(Location_X) - Add_X) + "-" + str(int(Location_Y) - Add_Y))
		if Flow.get_node(str(int(Location_X) - Add_X) + "-" + str(int(Location_Y) - Add_Y)).get_child_count() != 0:
			break
		Add_X += 1
		Add_Y += 1

func Get_Horse():
	var The_X = 2
	var The_Y = 1
	var number = 0
	while number != 8:
		# So this one is interesting. This is most likely the cleanest code here.
		# Get the numbers, replace the numbers, and loop until it stops.
		if not Is_Null(str(int(Location_X) + The_X) + "-" + str(int(Location_Y) + The_Y)):
			Areas.append(str(int(Location_X) + The_X) + "-" + str(int(Location_Y) + The_Y))
		number += 1
		match number:
			1:
				The_X = 1
				The_Y = 2
			2:
				The_X = -2
				The_Y = 1
			3:
				The_X = -1
				The_Y = 2
			4:
				The_X = 2
				The_Y = -1
			5:
				The_X = 1
				The_Y = -2
			6:
				The_X = -2
				The_Y = -1
			7:
				The_X = -1
				The_Y = -2

func Castle():
	# This is the castling section right here, used if a person wants to castle.
	var Flow = get_node("Flow")
	var X_Counter = 1
	# These are very similar to gathering a row, except we want free tiles and a rook
	# Counting up
	while not Is_Null(str(int(Location_X) + X_Counter) + "-" + Location_Y) && Flow.get_node(str(int(Location_X) + X_Counter) + "-" + Location_Y).get_child_count() == 0:
		X_Counter += 1
	if not Is_Null(str(int(Location_X) + X_Counter) + "-" + Location_Y) && Flow.get_node(str(int(Location_X) + X_Counter) + "-" + Location_Y).get_child(0).name == "Rook":
		if Flow.get_node(str(int(Location_X) + X_Counter) + "-" + Location_Y).get_child(0).Castling == true:
			Areas.append(str(int(Location_X) + X_Counter) + "-" + Location_Y)
			Special_Area.append(str(int(Location_X) + 1) + "-" + Location_Y)
			Special_Area.append(str(int(Location_X) + 2) + "-" + Location_Y)
	# Counting down
	X_Counter = -1
	while not Is_Null(str(int(Location_X) + X_Counter) + "-" + Location_Y) && Flow.get_node(str(int(Location_X) + X_Counter) + "-" + Location_Y).get_child_count() == 0:
		X_Counter -= 1
	if not Is_Null(str(int(Location_X) + X_Counter) + "-" + Location_Y) && Flow.get_node(str(int(Location_X) + X_Counter) + "-" + Location_Y).get_child(0).name == "Rook":
		if Flow.get_node(str(int(Location_X) + X_Counter) + "-" + Location_Y).get_child(0).Castling == true:
			Areas.append(str(int(Location_X) + X_Counter) + "-" + Location_Y)
			Special_Area.append(str(int(Location_X) - 1) + "-" + Location_Y)
			Special_Area.append(str(int(Location_X) - 2) + "-" + Location_Y)

# One function that shortens everything. Its also a pretty good way to see if we went off the board or not.
func Is_Null(Location):
	if get_node_or_null("Flow/" + Location) == null:
		return true
	else:
		return false
