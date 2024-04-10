extends TileMap

@onready var gridLengthX = get_used_rect().size.x
@onready var gridLengthY = get_used_rect().size.y
var oppFac

func _ready():
	SignalBus.connect("updateGrid", update_grid_collision)
	AutoloadMe.initialize_grid(gridLengthX, gridLengthY)

func update_grid_collision():
	AutoloadMe.movementGrid.update()
	for x in gridLengthX:
		for y in gridLengthY:
			var tilePos = Vector2i(x,y)
			
			var tileData = get_cell_tile_data(0, tilePos)
			
			if tileData == null or tileData.get_custom_data("walkable") == false:
				AutoloadMe.movementGrid.set_point_solid(tilePos)
			
			# Looks thru the unitList, determines if the 
			for i in AutoloadMe.globalUnitList.size():
				match[local_to_map(AutoloadMe.globalUnitList[i].position) == tilePos, AutoloadMe.isAllyTurn, AutoloadMe.globalUnitList[i].get_faction() == 1]:
					[true,true,true]:
						AutoloadMe.movementGrid.set_point_solid(tilePos)

func set_enemy_collision():
	AutoloadMe.movementGrid.update()
	for x in gridLengthX:
		for y in gridLengthY:
			var tilePos = Vector2i(x,y)
			
			var tileData = get_cell_tile_data(0, tilePos)
			
			if tileData == null or tileData.get_custom_data("walkable") == false:
				AutoloadMe.movementGrid.set_point_solid(tilePos)
			
			for i in AutoloadMe.globalEnemyList.size():
				if local_to_map(AutoloadMe.globalEnemyList[i].position) == tilePos and AutoloadMe.globalEnemyList[i] != AutoloadMe.turnPointer:
					AutoloadMe.movementGrid.set_point_solid(tilePos)


func convert_to_map(localPos):
	return local_to_map(localPos)

