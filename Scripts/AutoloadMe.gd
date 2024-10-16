extends Node

@onready var tile_size = Vector2i(64, 64)
var movementGrid = AStarGrid2D.new()
var abilityRangeGrid = AStarGrid2D.new()
var abilityRangeGridUI = AStarGrid2D.new()
var gridSize
var turnPointer
var passingUnit = null
var isAllyTurn = false
var globalUnitList
var globalAllyList
var globalEnemyList
var globalTargetList
var unitDying = false
var validQueue = false
var queueState = false
var allowEndTurn = true
var deathCount = 0
var bossdead = false
#var finalBattle = false
var siphonsDestroyed = 0
var hoveredUnit = null
var notOverlapped = true
var isExecuting = false
var roundNum = 1
var currentAbility
var passingAP
var mapID
var ThorGardenDeath = false
var enemyPhase = false

# Save data variables
var savePath = "user://variable.save"
var level = 1 # 1=Tutorial, 2=Cathedral 1, 3=Garden, 4=Cathedral 2, 5=Finale
#level increments whenever a new stage is loaded
#and returns to 1 when beating the game

var inputs = {"move_right": Vector2.RIGHT,
			"move_left": Vector2.LEFT,
			"move_up": Vector2.UP,
			"move_down": Vector2.DOWN}

func _ready():
	print("I AM BORNE")
	SignalBus.connect("currentUnit",set_current_unit)
	SignalBus.connect("activelyQueueing", valid_spot_queued)
	SignalBus.connect("abilityIsQueued", queue_active)

func new_level():
	enemyPhase = false
	deathCount = 0
	siphonsDestroyed = 0
	roundNum = 1
	Dialogic.VAR.StoryProgress = 0

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
	
	abilityRangeGridUI.size = gridSize
	abilityRangeGridUI.cell_size = tile_size
	abilityRangeGridUI.offset = tile_size / 2
	abilityRangeGridUI.update()
	abilityRangeGridUI.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

func _unhandled_input(event):
	if turnPointer == null:
		print("NO UNIT")
		return
	
	if Input.is_action_pressed("right_click"):
		SignalBus.moveCamera.emit()
	
	if Input.is_action_just_released("right_click"):
		SignalBus.showUI.emit()
	
	if Input.is_action_just_pressed("zoom_in"):
		SignalBus.adjustZoom.emit(0.5)
		
	if Input.is_action_just_pressed("zoom_out"):
		SignalBus.adjustZoom.emit(-0.5)
	
	if Dialogic.VAR.CutsceneUp == true: return
	
	if turnPointer.Faction == turnPointer.fac.ALLY:
		if turnPointer.moving:
			return
		for dir in inputs.keys():
			if event.is_action_pressed(dir) and !turnPointer.abilityQueued:
				if turnPointer.isDown: return
				turnPointer.get_node("AnimatedSprite2D").stop()
				turnPointer.get_node("AnimatedSprite2D").play("Jump1")
				turnPointer.move(inputs[dir])
		
# Sometimes "left_click" double clicks(usually if you click while dragging the mouse across the screen) idk why. Is definitely this line below and only happens with mouse inputs!!!!!!!!!!!!!!!!!
		if Input.is_action_just_pressed("left_click"):
			if event is InputEventMouseButton and event.is_double_click():
				#print("-----------",event)
				#print("I AM A DOUBLE CLICK")
				#print(currentAbility.targetUnits)
				#print(hoveredUnit)
				#print(isExecuting, " ", validQueue, " ", queueState, " ", currentAbility.targetUnits.has(hoveredUnit))
				if !isExecuting and validQueue and queueState:
					if currentAbility.targetUnits.has(hoveredUnit):
						#print("ABOUT TO EXECUTE")
						AutoloadMe.set_process_unhandled_input(false)
						isExecuting = true
						turnPointer.run_passives(turnPointer.methodType.ABILITY_EXECUTE, null)
						turnPointer.abilityQueued.execute()
			
			##NOTE: Below is for debug purposes
			#Dialogic.VAR.DialogueComplete = true
			
			if turnPointer.abilityQueued != null:
				turnPointer.abilityQueued.queue()
		
		if Input.is_action_just_pressed("trigger_ability") and !isExecuting:
			print(validQueue, " ", queueState)
			if validQueue == true and queueState == true:
				AutoloadMe.set_process_unhandled_input(false)
				isExecuting = true
				turnPointer.run_passives(turnPointer.methodType.ABILITY_EXECUTE, null)
				turnPointer.abilityQueued.execute()
		
		if Input.is_action_just_pressed("end_turn") and !isExecuting and queueState == false and notOverlapped == true and allowEndTurn == true:
			if Dialogic.VAR.DialogueComplete == true or turnPointer.isPossessed:
				turnPointer.on_turn_end()
	
	else: return

func valid_spot_queued(status):
	if status == true:
		validQueue = true
		SignalBus.changeControls.emit()
	else:
		validQueue = false

func queue_active():
	queueState = true
	SignalBus.changeControls.emit()

func set_current_unit(unit):
	turnPointer = unit
	if (turnPointer.get_faction() == 0):
		isAllyTurn = true
	else: 
		isAllyTurn = false
	
	SignalBus.updateGrid.emit()

func start_first_turn():
	SignalBus.endTurn.emit()
	
func start_next_round():
	SignalBus.endRound.emit()

func play_music(fileName):
	SignalBus.playMusic.emit(fileName)
	
func play_sfx(fileName):
	SignalBus.playSFX.emit(fileName)
	
# Save data
# Call this when a new level starts, after "level" is updated
func save():
	var file = FileAccess.open(savePath,FileAccess.WRITE)
	file.store_var(level)
	
# Load data
# Call this when playing game from main menu
func load_data():
	if FileAccess.file_exists(savePath):
		var file = FileAccess.open(savePath, FileAccess.READ)
		level = file.get_var(level)
	else:
		level = 1
		print("No data saved...")
		
# TODO: Add save() and load_data() calls where appropriate
