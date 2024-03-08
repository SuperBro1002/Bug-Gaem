extends Node

var stab = load("res://Abilities/Stab/Stab.tscn")

@export var damage = 0
@export var tileRange = 1
var actualRange = 64
var caster
var direction = null
var clickedPos
var targetUnits
var targetTiles

func _ready():
	SignalBus.connect("ability",dequeue)
	range_convert()
	#print($Hitbox.target_position)

func range_convert():
	actualRange = tileRange * AutoloadMe.tile_size.x
	$Hitbox.target_position = Vector2(0, actualRange)

func queue():
	# Use AStar to calc valid AOE range
	# Use AOE box to calc all targets
	# Use rays to check LOS
	# Use AStar to calc all valid targets
	if get_parent().Name == AutoloadMe.turnPointer.Name:
		clickedPos = get_parent().grid.get_global_mouse_position()
		clickedPos = get_parent().grid.convert_to_map(clickedPos)
	
		print(clickedPos)
	
	SignalBus.abilityIsQueued.emit()

func dequeue(num, state):
	if state == false:
		clickedPos = null

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	SignalBus.abilityExecuted.emit()

