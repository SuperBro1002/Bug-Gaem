extends TileMap

#var astarGrid = AStarGrid2D.new()
#var gridSize
#@onready var start = local_to_map($Ally.position)
#@onready var end = local_to_map($Ally.position)
#@onready var tileSize = AutoloadMe.tile_size

@onready var gridX = get_used_rect().size.x
@onready var gridY = get_used_rect().size.y

func _ready():
	SignalBus.connect("updateGrid", redraw_grid)
	AutoloadMe.initialize_grid(gridX, gridY)
	redraw_grid()

func redraw_grid():
	for x in gridX:
		for y in gridY:
			var tilePos = Vector2i(x,y)
			
			var tileData = get_cell_tile_data(0, tilePos)
			
			if tileData == null or tileData.get_custom_data("walkable") == false:
				AutoloadMe.astarGrid.set_point_solid(tilePos)

func convert_to_local(localPos):
	return local_to_map(localPos)

