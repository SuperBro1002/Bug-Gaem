@tool
extends Node
class_name Ability_class

var Tackle
var Name
var fileName
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
@export var canRotate = false

var dmgMod = 1
var targetType = []
var clickedPos
var targetUnits = []
var clickedDistance
var areaType = "selection_box"
@onready var abilityGrid = AutoloadMe.abilityRangeGrid

func _ready():
	SignalBus.connect("ability",dequeue)
	SignalBus.connect("showRangeTiles", draw_range_tiles)
	SignalBus.connect("endRangeTiles", kill_range_tiles)
	$Area2D.position = Vector2(-900,-900)
	$Area2D/SelectionBox.set_visible(false)

func queue():
	AutoloadMe.currentAbility = self
	if get_parent().get_temp_ap() - apCost >= 0:
		clickedPos = get_parent().grid.get_global_mouse_position()
		clickedPos = get_parent().grid.local_to_map(clickedPos)
		if !abilityGrid.is_in_bounds(clickedPos.x, clickedPos.y):
			return
		clickedDistance = abilityGrid.get_point_path(get_parent().abilityStartPoint,clickedPos)
		
		for i in AutoloadMe.globalTargetList.size() - 1:
			if clickedPos == AutoloadMe.globalTargetList[i].grid.local_to_map(AutoloadMe.globalTargetList[i].position):
				if clickedDistance.size() - 1 <= distanceRange and type_matches(AutoloadMe.globalTargetList[i].get_faction()) and clickedPos != get_parent().grid.local_to_map(get_parent().position):
					print("ME ", clickedPos != get_parent().grid.local_to_map(get_parent().position))
					if canRotate:
						rotate(clickedPos)
					$Area2D.position = get_parent().grid.map_to_local(clickedPos)
					$Area2D/SelectionBox.set_visible(true)
					
					await get_tree().create_timer(0.1).timeout
					
					if !targetUnits.is_empty():
						SignalBus.activelyQueueing.emit(true)
					else:
						SignalBus.activelyQueueing.emit(false)
					print(targetUnits)

func type_matches(faction):
	for i in targetType:
		if faction == i:
			print("IM HERE")
			return true
	return false

func rotate(initTarget):
	initTarget = get_parent().grid.map_to_local(initTarget)
	if initTarget.x > get_parent().position.x:
		$Area2D.set_rotation_degrees(0)
		print("Right")
	elif initTarget.x < get_parent().position.x:
		$Area2D.set_rotation_degrees(180)
		print("Left")
	elif initTarget.y < get_parent().position.y:
		$Area2D.set_rotation_degrees(270)
		print("Above")
	elif initTarget.y > get_parent().position.y:
		$Area2D.set_rotation_degrees(90)
		print("Below")

func dequeue(num, state):
	if state == false:
		clickedPos = null
		$Area2D/SelectionBox.set_visible(false)
		$Area2D.position = Vector2(-900,-900)
		kill_range_tiles()

func execute():
	pass

func enemy_execute(initTarget):
	targetUnits.append(initTarget)
	$Area2D/SelectionBox.set_visible(true)
	if initTarget.position.x > get_parent().position.x:
		$Area2D.set_rotation_degrees(0)
		#print("Right")
	elif initTarget.position.x < get_parent().position.x:
		$Area2D.set_rotation_degrees(180)
		#print("Left")
	elif initTarget.position.y < get_parent().position.y:
		$Area2D.set_rotation_degrees(270)
		#print("Above")
	elif initTarget.position.y > get_parent().position.y:
		$Area2D.set_rotation_degrees(90)
		#print("Below")
	$Area2D.position = initTarget.position
	await get_tree().create_timer(0.7).timeout
	execute()

func post_execute():
	dmgMod = 1
	targetUnits.clear()
	get_parent().grid.update_grid_collision()
	SignalBus.abilityExecuted.emit(self)
	SignalBus.updateUI.emit(get_parent())
	AutoloadMe.isExecuting = false
	SignalBus.changeControls.emit()
	AutoloadMe.set_process_unhandled_input(true)
	if get_parent().Faction == get_parent().fac.ALLY:
		SignalBus.changeButtonState.emit()
	elif get_parent().Faction == get_parent().fac.ENEMY:
		dequeue(1,false)

func draw_range_tiles(activeName):
	if fileName != activeName:
		return
	print("Children: ", )
	SignalBus.playSFX.emit("Queue")
	if get_parent() == AutoloadMe.turnPointer:
		print(get_parent())
		var tiles = get_parent().grid.flood_fill_in_range(get_parent().position, distanceRange)
		tiles = get_parent().grid.remove_solid(tiles)
		var sceneNode
		print("TILES: ", tiles)
		for i in tiles.size():
			var scene = load("res://Scenes/Ability_Tile.tscn")
			sceneNode = scene.instantiate()
			$AbilityRanges.add_child(sceneNode)
			sceneNode.position = tiles[i]
		#kill_range_tiles()

func kill_range_tiles():
	if get_parent() == AutoloadMe.turnPointer:
		var tiles = $AbilityRanges.get_children()
		for i in tiles.size():
			tiles.pop_back().queue_free()

func get_ap_cost():
	return apCost

func face_target():
	print("Targets: ", targetUnits)
	if targetUnits[0].position.x < get_parent().position.x:
		get_parent().get_node("AnimatedSprite2D").set_flip_h(true)
	else:
		get_parent().get_node("AnimatedSprite2D").set_flip_h(false)

func target_is_right():
	if targetUnits[0].position.x < get_parent().position.x:
		return false
	else:
		return true

func _on_area_2d_area_entered(area):
	if AutoloadMe.turnPointer.get_faction() == get_parent().fac.ALLY:
		if area.areaType != "spawner" and area.areaType != "range_box" and type_matches(area.get_faction()) and area != get_parent() and targetUnits.find(area) == -1:
			print("HI")
			targetUnits.append(area)
			print("SIZE OF TARGET",targetUnits.size())
	elif AutoloadMe.turnPointer.get_faction() == get_parent().fac.ENEMY:
		print("Enemy hitbox entered")
		if area.areaType != "spawner" and area.areaType != "range_box" and (area.get_faction() == area.fac.ALLY or area.get_faction() == area.fac.OBSTACLE) and area != get_parent() and targetUnits.find(area) == -1:
			print(area)
			print("HI")
			targetUnits.append(area)
			print("SIZE OF TARGET",targetUnits.size())

func _on_area_2d_area_exited(area):
	if (area.get_parent() == self.get_parent().get_parent() or area.areaType == "obstacle") and AutoloadMe.turnPointer.get_faction() != get_parent().fac.ENEMY:
		print("Erased ", area)
		targetUnits.erase(area)
