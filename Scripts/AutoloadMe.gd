extends Node

@onready var tile_size = Vector2i(64, 64)
var astarGrid = AStarGrid2D.new()
var gridSize
var turnPointer

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

func _ready():
	print("I AM BORNE")
	SignalBus.connect("currentUnit",set_current_unit)

func initialize_grid():
	gridSize = Vector2i(18,10)# / tileSize
	astarGrid.size = gridSize
	astarGrid.cell_size = tile_size
	astarGrid.offset = tile_size / 2
	astarGrid.update()
	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

#	astarGrid.region = tileMap.get_used_rect()

func _unhandled_input(event):
	if turnPointer == null:
		print("NO UNIT")
		return
	if turnPointer.Faction == turnPointer.fac.ALLY:
		if turnPointer.moving:
			return
		for dir in inputs.keys():
			if event.is_action_pressed(dir) and !turnPointer.abilityQueued:
				turnPointer.move(inputs[dir])
				
		if event is InputEventKey:
			if event.pressed and event.keycode == KEY_SPACE:
				print("SPACE PRESSED")
				turnPointer.on_turn_end()
	else: return

func set_current_unit(unit):
	turnPointer = unit

