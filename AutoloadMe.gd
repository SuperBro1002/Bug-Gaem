extends Node

@onready var tile_size = Vector2i(64, 64)
var astarGrid = AStarGrid2D.new()
var gridSize

func _ready():
	print("I AM BORNE")
	initialize_grid()

func initialize_grid():
	gridSize = Vector2i(18,10)# / tileSize
	astarGrid.size = gridSize
	astarGrid.cell_size = tile_size
	astarGrid.offset = tile_size / 2
	astarGrid.update()
	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

#	astarGrid.region = tileMap.get_used_rect()
