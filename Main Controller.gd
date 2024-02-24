extends Node2D

enum level {
	LEVEL1,
	LEVEL2,
	LEVEL3
}

var unitList = []
var test
var grid

func _ready():
	SignalBus.connect("endTurn", testEnd)
	grid = $Grid
	AutoloadMe.initialize_grid()
	for x in grid.get_used_rect().size.x:
		for y in grid.get_used_rect().size.y:
			var tilePos = Vector2i(x,y)
			
			var tileData = grid.get_cell_tile_data(0, tilePos)
			
			if tileData == null or tileData.get_custom_data("walkable") == false:
				AutoloadMe.astarGrid.set_point_solid(tilePos)

func process():
	pass

func testEnd():
	print("END TURN")
