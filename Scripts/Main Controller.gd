extends Node2D

var unitList = []
var test
var grid
# = get_node("Grid/InitManager/UnitManager/Ally")

func _ready():
	
	grid = $Grid
	AutoloadMe.initialize_grid()
	for x in grid.get_used_rect().size.x:
		for y in grid.get_used_rect().size.y:
			var tilePos = Vector2i(x,y)
			
			var tileData = grid.get_cell_tile_data(0, tilePos)
			
			if tileData == null or tileData.get_custom_data("walkable") == false:
				AutoloadMe.astarGrid.set_point_solid(tilePos)
	
	get_node("Grid/InitManager").next_turn()

func process():
	pass
