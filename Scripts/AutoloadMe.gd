extends Node

@onready var tile_size = Vector2i(64, 64)
var astarGrid = AStarGrid2D.new()
var gridSize
var turnPointer

var inputs = {"move_right": Vector2.RIGHT,
			"move_left": Vector2.LEFT,
			"move_up": Vector2.UP,
			"move_down": Vector2.DOWN}

func _ready():
	print("I AM BORNE")
	SignalBus.connect("currentUnit",set_current_unit)

func initialize_grid(gridX, gridY):
	gridSize = Vector2i(gridX,gridY)
	astarGrid.size = gridSize
	astarGrid.cell_size = tile_size
	astarGrid.offset = tile_size / 2
	astarGrid.update()
	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

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
			if Input.is_action_pressed("space"):
				print("space pressed")
				turnPointer.on_turn_end()
	else: return

func set_current_unit(unit):
	turnPointer = unit

