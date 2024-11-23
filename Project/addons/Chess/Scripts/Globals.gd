extends Node

# Define a global matrix (e.g., 8x8 for a chessboard)
var global_matrix = []

# Initialize the matrix in the `_ready` function or dynamically
func _ready():
	global_matrix = []
	for i in range(8):  # Create an 8x8 matrix
		global_matrix.append([])
		for j in range(8):
			global_matrix[i].append(null)  # Initialize with null or a default value

func print_matrix():
	for row in global_matrix:
		print(row)
