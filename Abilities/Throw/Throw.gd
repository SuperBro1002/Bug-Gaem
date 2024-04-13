extends Ability_class

#@export var apCost = 0
#@export var tileRange = 1
#@export var distanceRange = 1
#var targetType = 0
#var actualRange = 64
#var caster
#var direction = null
#var clickedPos
#var targetUnits = []
#var targetTiles
#var clickedDistance
#@onready var abilityGrid = AutoloadMe.abilityRangeGrid

var occupiedPos = false
var collatUnit
var newPos
var bouncePos
var validTargetPos

func _enter_tree():
	$Area2D2/SelectionBox.set_visible(false)
	targetType = get_parent().fac.ALLY
	description = "Select an adjacent unit to throw to a space within 6 tiles. If there is a unit in the target's new space, both units take 4 damage and the former is pushed off the tile. Unit being thrown gains Baton Pass."

func queue():
	collatUnit = null
	validTargetPos = false
	occupiedPos = false
	if AutoloadMe.validQueue == false:
		if get_parent().get_temp_ap() - apCost >= 0: # Checks if parent has enough AP
			clickedPos = get_parent().grid.get_global_mouse_position()
			clickedPos = get_parent().grid.local_to_map(clickedPos) # Grabs mouse pos and converts it to grid
			clickedDistance = abilityGrid.get_point_path(get_parent().abilityStartPoint,clickedPos) # Makes a list of the shortest path of tiles between the parent and clickedPos
			
			for i in AutoloadMe.globalUnitList.size() - 1:
				if clickedPos == AutoloadMe.globalUnitList[i].grid.local_to_map(AutoloadMe.globalUnitList[i].position): # Checks if a unit is present at clickedPos
					if clickedDistance.size() - 1 <= distanceRange and AutoloadMe.globalUnitList[i].get_faction() == targetType: # Checks if ClickedPos is within the ability's designated tile range and is the proper alignment
						$Area2D.position = get_parent().grid.map_to_local(clickedPos) # Moves the collision box to clickedPos. If any unit is within this box, they are added to a targetList
						$Area2D/SelectionBox.set_visible(true)
						
						await get_tree().create_timer(0.1).timeout
						
						if !targetUnits.is_empty(): # Checks if a target is found and signals if the game can allow an input to trigger the execute method
							SignalBus.activelyQueueing.emit(true)
						else:
							SignalBus.activelyQueueing.emit(false)
						
						print(targetUnits)
	else:
		newPos = get_parent().grid.get_global_mouse_position()
		newPos = get_parent().grid.local_to_map(newPos) # Grabs mouse pos and converts it to grid
		clickedDistance = abilityGrid.get_point_path(get_parent().abilityStartPoint,newPos) # Makes a list of the shortest path of tiles between the parent and clickedPos
		print(clickedDistance.size() - 1)
		if clickedDistance.size() - 1 <= 6 and newPos.x >= 1 and newPos.y >= 1 and newPos.x <= AutoloadMe.gridSize.x - 2 and newPos.y <= AutoloadMe.gridSize.y - 2:
			validTargetPos = true
			for i in AutoloadMe.globalUnitList.size() - 1:
				if newPos == AutoloadMe.globalUnitList[i].grid.local_to_map(AutoloadMe.globalUnitList[i].position):
					occupiedPos = true
					collatUnit = AutoloadMe.globalUnitList[i]
					bouncePos = get_parent().grid.flood_fill_first(newPos)
					
			$Area2D2.position = get_parent().grid.map_to_local(newPos)
			$Area2D2/SelectionBox.set_visible(true)
		
		
	# Store mouse position after left click
	# Find the shortest path between parent and target position
	# Check if its in range
	# Check if target position is occupied
	# If occupied, find an the nearest open tile and note it for damage later
	# Move target to target position

func execute():
	if newPos != null and validTargetPos == true:
		print("EXECUTED Throw")
		print(targetUnits)
	
		for i in targetUnits.size():
			targetUnits[i].position = get_parent().grid.map_to_local(newPos)
			
			targetUnits[i].abilityStartPoint = targetUnits[i].grid.convert_to_map(newPos) # CHANGE WHEN COLLATERAL MOVEMENT IS ADDED
			
			if occupiedPos == true:
				#Tweens target to the bouncePos
				targetUnits[i].lose_health(4)
				collatUnit.lose_health(4)
				#await get_tree().create_timer(0.5).timeout
				targetUnits[i].position = get_parent().grid.map_to_local(bouncePos)
				targetUnits[i].abilityStartPoint = targetUnits[i].grid.convert_to_map(bouncePos)
			
			targetUnits[i].give_batonpass()
		
		post_execute()

func dequeue(_num, state):
	if state == false:
		clickedPos = null
		newPos = null
		$Area2D/SelectionBox.set_visible(false)
		$Area2D.position = Vector2(0,0)
		$Area2D2/SelectionBox.set_visible(false)
		$Area2D2.position = Vector2(0,0)

