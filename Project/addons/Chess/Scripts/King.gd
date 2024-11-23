@tool
extends Pawn
class_name King

var Castling = true

func _ready():
	self.texture = load("res://addons/Chess/pixel_figures/piece6.png")
	self.scale = Vector2(3, 3)

func _process(_delta):
	if Item_Color != Temp_Color:
		Temp_Color = Item_Color
		if Item_Color == 0:
			self.texture = load("res://addons/Chess/pixel_figures/piece6.png")
		elif Item_Color == 1:
			self.texture = load("res://addons/Chess/pixel_figures/piece12.png")
