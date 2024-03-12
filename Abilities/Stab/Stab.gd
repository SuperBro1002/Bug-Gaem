extends Node

var stab = load("res://Abilities/Stab/Stab.tscn")
var Name = "Stab"

@export var damage = 0
@export var tileRange = 1
@export var distanceRange = 1
var actualRange = 64
var caster
var direction = null
var clickedPos
var targetUnits = []
var targetTiles
var clickedDistance
@onready var abilityGrid = AutoloadMe.abilityRangeGrid

func _ready():
	SignalBus.connect("ability",dequeue)
	range_convert()
	$Area2D/SelectionBox.set_visible(false)
	#$Area2D.scale = Vector2(tileRange,tileRange)
	#print($Hitbox.target_position)

func range_convert():
	actualRange = tileRange * AutoloadMe.tile_size.x
	$Hitbox.target_position = Vector2(0, actualRange)

func queue():
	# Use AStar to calc valid AOE range
	# Use AOE box to calc all targets
	# Use AStar to calc all valid targets
	if get_parent().Name == AutoloadMe.turnPointer.Name:
		clickedPos = get_parent().grid.get_global_mouse_position()
		clickedPos = get_parent().grid.local_to_map(clickedPos)
		clickedDistance = abilityGrid.get_point_path(get_parent().abilityStartPoint,clickedPos)
		
		if clickedDistance.size() - 1 <= distanceRange:
			$Area2D.position = get_parent().grid.map_to_local(clickedPos)
			$Area2D/SelectionBox.set_visible(true)
			
			await get_tree().create_timer(0.1).timeout
			
			if !targetUnits.is_empty():
				SignalBus.activelyQueueing.emit(true)
			else:
				SignalBus.activelyQueueing.emit(false)
			
			print(targetUnits)

func dequeue(num, state):
	if state == false:
		clickedPos = null
		$Area2D/SelectionBox.set_visible(false)
		$Area2D.position = Vector2(0,0)

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	for i in targetUnits.size():
		targetUnits[i].lose_health(7)
	
	SignalBus.updateUI.emit(get_parent())
	SignalBus.abilityExecuted.emit()

func _on_area_2d_area_entered(area):
	targetUnits.append(area)

func _on_area_2d_area_exited(area):
	targetUnits.erase(area)
