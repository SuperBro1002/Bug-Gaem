@tool
extends Node
class_name Ability_class

var Tackle
var Name
var description

enum abilityType{
	DAMAGING,
	HEALING,
	STATUS,
	NEUTRAL
}

#@export var damage = 0
@export var apCost = 0
@export var distanceRange = 1
@export var myType = abilityType.DAMAGING

var dmgMod = 1
var targetType = 0
var clickedPos
var targetUnits = []
var clickedDistance
@onready var abilityGrid = AutoloadMe.abilityRangeGrid

func _ready():
	SignalBus.connect("ability",dequeue)
	$Area2D/SelectionBox.set_visible(false)

func queue():
	AutoloadMe.currentAbility = self
	if get_parent().get_temp_ap() - apCost >= 0:
		clickedPos = get_parent().grid.get_global_mouse_position()
		clickedPos = get_parent().grid.local_to_map(clickedPos)
		if !abilityGrid.is_in_bounds(clickedPos.x, clickedPos.y):
			return
		clickedDistance = abilityGrid.get_point_path(get_parent().abilityStartPoint,clickedPos)
		
		for i in AutoloadMe.globalUnitList.size() - 1:
			if clickedPos == AutoloadMe.globalUnitList[i].grid.local_to_map(AutoloadMe.globalUnitList[i].position):
				if clickedDistance.size() - 1 <= distanceRange and AutoloadMe.globalUnitList[i].get_faction() == targetType and clickedPos != get_parent().grid.local_to_map(get_parent().position):
					print("ME ", clickedPos != get_parent().grid.local_to_map(get_parent().position))
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
	dmgMod = 1
	targetUnits.clear()
	get_parent().grid.update_grid_collision()
	SignalBus.abilityExecuted.emit(self)
	SignalBus.updateUI.emit(get_parent())
	AutoloadMe.isExecuting = false
	if get_parent().Faction == get_parent().fac.ALLY:
		SignalBus.changeButtonState.emit()

func get_ap_cost():
	return apCost

func _on_area_2d_area_entered(area):
	if area.get_parent() == self.get_parent().get_parent() and area.get_faction() == targetType and area != get_parent():
		print("HI")
		targetUnits.append(area)

func _on_area_2d_area_exited(area):
	if area.get_parent() == self.get_parent().get_parent():
		targetUnits.erase(area)
