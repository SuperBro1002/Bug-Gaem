extends TileMap

var astarGrid = AStarGrid2D.new()
var gridSize
@onready var start = local_to_map($Ally.position)
@onready var end = local_to_map($Ally.position)
@onready var tileSize = AutoloadMe.tile_size

func _ready():
	initialize_grid()

func initialize_grid():
	gridSize = Vector2i(10,10)# / tileSize
	astarGrid.size = gridSize
	astarGrid.cell_size = tileSize
	astarGrid.offset = tileSize / 2
	astarGrid.update()
	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
