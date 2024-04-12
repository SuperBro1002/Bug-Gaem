@tool
extends Node
class_name Ability_class

var Tackle
var Name
var description

#@export var damage = 0
@export var apCost = 0
@export var tileRange = 1
@export var distanceRange = 1
var targetType = 0
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

func range_convert():
	actualRange = tileRange * AutoloadMe.tile_size.x
	$Hitbox.target_position = Vector2(0, actualRange)

func queue():
	if get_parent().get_temp_ap() - apCost >= 0:
		clickedPos = get_parent().grid.get_global_mouse_position()
		clickedPos = get_parent().grid.local_to_map(clickedPos)
		if !abilityGrid.is_in_bounds(clickedPos.x, clickedPos.y):
			return
		clickedDistance = abilityGrid.get_point_path(get_parent().abilityStartPoint,clickedPos)
		
		for i in AutoloadMe.globalUnitList.size() - 1:
			if clickedPos == AutoloadMe.globalUnitList[i].grid.local_to_map(AutoloadMe.globalUnitList[i].position):
				if clickedDistance.size() - 1 <= distanceRange and AutoloadMe.globalUnitList[i].get_faction() == targetType:
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
	pass

func post_execute():
	targetUnits.clear()
	SignalBus.abilityExecuted.emit(self)
	SignalBus.updateUI.emit(get_parent())
	AutoloadMe.isExecuting = false
	if get_parent().Faction == get_parent().fac.ALLY:
		SignalBus.changeButtonState.emit()

func get_ap_cost():
	return apCost

func _on_area_2d_area_entered(area):
	if area.get_faction() == targetType:
		targetUnits.append(area)

func _on_area_2d_area_exited(area):
	targetUnits.erase(area)
