extends Node2D

enum level {
	LEVEL1,
	LEVEL2,
	LEVEL3
}

var unitList = []
var test
var grid
var turnPointer# = get_node("Grid/InitManager/UnitManager/Ally")

func _ready():
	SignalBus.connect("currentUnit",set_current_unit)
	
	grid = $Grid
	AutoloadMe.initialize_grid()
	for x in grid.get_used_rect().size.x:
		for y in grid.get_used_rect().size.y:
			var tilePos = Vector2i(x,y)
			
			var tileData = grid.get_cell_tile_data(0, tilePos)
			
			if tileData == null or tileData.get_custom_data("walkable") == false:
				AutoloadMe.astarGrid.set_point_solid(tilePos)
	
	get_node("Grid/InitManager").next_turn()

func set_current_unit(unit):
	turnPointer = unit

func _unhandled_input(event):
	if turnPointer == null:
		print("NO UNIT")
		return
	if turnPointer.Faction == turnPointer.fac.ALLY:
		if turnPointer.moving:
			return
		for dir in turnPointer.inputs.keys():
			if event.is_action_pressed(dir):
				turnPointer.move(dir)
		if event is InputEventKey:
			if event.pressed and event.keycode == KEY_SPACE:
				print("SPACE PRESSED")
				turnPointer.on_turn_end()
	else: return


func process():
	pass
