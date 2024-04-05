extends Node

@onready var tile_size = Vector2i(64, 64)
var movementGrid = AStarGrid2D.new()
var abilityRangeGrid = AStarGrid2D.new()
var gridSize
var turnPointer
var isAllyTurn = false
var globalUnitList
var globalAllyList
var globalEnemyList
var validQueue = false
var queueState = false
var deathCount = 0
var hoveredUnit = null
var notOverlapped = true

var inputs = {"move_right": Vector2.RIGHT,
			"move_left": Vector2.LEFT,
			"move_up": Vector2.UP,
			"move_down": Vector2.DOWN}

func _ready():
	print("I AM BORNE")
	SignalBus.connect("currentUnit",set_current_unit)
	SignalBus.connect("activelyQueueing", valid_spot_queued)
	SignalBus.connect("abilityIsQueued", queue_active)

func initialize_grid(gridLengthX, gridLengthY):
	gridSize = Vector2i(gridLengthX,gridLengthY)
	movementGrid.size = gridSize
	movementGrid.cell_size = tile_size
	movementGrid.offset = tile_size / 2
	movementGrid.update()
	movementGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	abilityRangeGrid.size = gridSize
	abilityRangeGrid.cell_size = tile_size
	abilityRangeGrid.offset = tile_size / 2
	abilityRangeGrid.update()
	abilityRangeGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

func _unhandled_input(event):
	if turnPointer == null:
		print("NO UNIT")
		return
	
	if Input.is_action_just_pressed("right_click"):
		SignalBus.moveCamera.emit()
		
	if Input.is_action_just_pressed("zoom_in"):
		SignalBus.adjustZoom.emit(0.5)
		
	if Input.is_action_just_pressed("zoom_out"):
		SignalBus.adjustZoom.emit(-0.5)
	
	
	if turnPointer.Faction == turnPointer.fac.ALLY:
		if turnPointer.moving:
			return
		for dir in inputs.keys():
			if event.is_action_pressed(dir) and !turnPointer.abilityQueued:
				turnPointer.move(inputs[dir])
		
# Sometimes "left_click" double clicks(usually if you click while dragging the mouse across the screen) idk why. Is definitely this line below and only happens with mouse inputs!!!!!!!!!!!!!!!!!
		if Input.is_action_just_pressed("left_click"):
			if turnPointer.abilityQueued != null:
				turnPointer.abilityQueued.queue()
		
		if Input.is_action_just_pressed("space"):
			print(validQueue, " ", queueState)
			if validQueue == true and queueState == true:
				turnPointer.abilityQueued.execute()
			elif queueState == false and notOverlapped == true:
				print("space pressed")
				turnPointer.on_turn_end()
	
	else: return

func valid_spot_queued(status):
	if status == true:
		validQueue = true
	else:
		validQueue = false

func queue_active():
	queueState = true

func set_current_unit(unit):
	turnPointer = unit
	if (turnPointer.get_faction() == 0):
		isAllyTurn = true
	else: 
		isAllyTurn = false
	
	SignalBus.updateGrid.emit()
