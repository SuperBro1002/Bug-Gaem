extends Ability_class

var isCarrying = false
var storedUnit

func _enter_tree():
	targetType = [get_parent().fac.ALLY]
	Name = "Carry"
	description = "Deals 2 damage to a single target. 4 AP"

func queue():
	AutoloadMe.currentAbility = self
	if isCarrying == false:
		print("STEP 1")
		if get_parent().get_temp_ap() - apCost >= 0:
			clickedPos = get_parent().grid.get_global_mouse_position()
			clickedPos = get_parent().grid.local_to_map(clickedPos)
			if !abilityGrid.is_in_bounds(clickedPos.x, clickedPos.y):
				return
			clickedDistance = abilityGrid.get_point_path(get_parent().abilityStartPoint,clickedPos)
			
			for i in AutoloadMe.globalUnitList.size() - 1:
				if clickedPos == AutoloadMe.globalUnitList[i].grid.local_to_map(AutoloadMe.globalUnitList[i].position):
					if clickedDistance.size() - 1 <= distanceRange and type_matches(AutoloadMe.globalUnitList[i].get_faction()) and clickedPos != get_parent().grid.local_to_map(get_parent().position):
						$Area2D.position = get_parent().grid.map_to_local(clickedPos)
						$Area2D/SelectionBox.set_visible(true)
						
						await get_tree().create_timer(0.1).timeout
						
						if !targetUnits.is_empty():
							SignalBus.activelyQueueing.emit(true)
						else:
							SignalBus.activelyQueueing.emit(false)
						
						print(targetUnits)
	else:
		print("STEP 2")
		if get_parent().get_temp_ap() - apCost >= 0:
			clickedPos = get_parent().grid.get_global_mouse_position()
			clickedPos = get_parent().grid.local_to_map(clickedPos)
			if !abilityGrid.is_in_bounds(clickedPos.x, clickedPos.y):
				return
			clickedDistance = abilityGrid.get_point_path(get_parent().abilityStartPoint,clickedPos)
			
			for i in AutoloadMe.globalUnitList.size() - 1:
				if clickedPos == AutoloadMe.globalUnitList[i].grid.local_to_map(AutoloadMe.globalUnitList[i].position) or AutoloadMe.movementGrid.is_point_solid(clickedPos):
					return
			if clickedDistance.size() - 1 <= distanceRange:
				$Area2D.position = get_parent().grid.map_to_local(clickedPos)
				$Area2D/SelectionBox.set_visible(true)
				
				await get_tree().create_timer(0.1).timeout
				
				SignalBus.activelyQueueing.emit(true)

func dequeue(num, state):
	if state == false and storedUnit == null:
		isCarrying = false
		clickedPos = null
		$Area2D/SelectionBox.set_visible(false)
		$Area2D.position = Vector2(0,0)

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	if !isCarrying:
		print("EXECUTED 1")
		print(targetUnits)
		AutoloadMe.allowEndTurn = false
		for i in targetUnits.size():
			if targetUnits == null:
				return
			storedUnit = targetUnits[i]
			storedUnit.position = Vector2(0,0)
			storedUnit.set_visible(false)
			isCarrying = true
			$Area2D/SelectionBox.set_visible(false)
			$Area2D.position = Vector2(0,0)
			post_execute()
	else:
		print("EXECUTED 2")
		storedUnit.position = get_parent().grid.map_to_local(clickedPos)
		storedUnit.set_visible(true)
		storedUnit.give_batonpass()
		
		isCarrying = false
		storedUnit = null
		AutoloadMe.allowEndTurn = true
		post_execute()
