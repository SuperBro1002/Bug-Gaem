extends Ability_class

var isCarrying = false
var storedUnit

func _enter_tree():
	targetType = [get_parent().fac.ALLY]
	Name = "Companion Carry"
	fileName = "Carry"
	description = "Pick up an adjacent ally. Re-use to place them down and grant baton pass. 2 AP"

func queue():
	AutoloadMe.currentAbility = self
	if isCarrying == false and AutoloadMe.turnPointer.get_temp_ap() - 2 >= 0:
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
				
				targetUnits.append(storedUnit)
				storedUnit.position = get_parent().grid.map_to_local(clickedPos)
				storedUnit.set_modulate(Color(1,1,1,0.5))
				storedUnit.set_visible(true)
				
				await get_tree().create_timer(0.1).timeout
				
				SignalBus.activelyQueueing.emit(true)

func dequeue(_num, state):
	if state == false and storedUnit == null:
		isCarrying = false
		clickedPos = null
		$Area2D/SelectionBox.set_visible(false)
		$Area2D.position = Vector2(-900,-900)
	elif storedUnit != null:
		storedUnit.set_visible(false)
		storedUnit.position = Vector2(0,0)
		targetUnits.erase(storedUnit)
		$Area2D/SelectionBox.set_visible(false)
		$Area2D.position = Vector2(-900,-900)

func post_execute2():
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
	#await get_tree().create_timer(1).timeout
	AutoloadMe.passingUnit = get_parent()
	#get_parent().on_turn_end()

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	if !isCarrying:
		print("EXECUTED 1")
		print(targetUnits)
		face_target()
		get_parent().get_node("AnimatedSprite2D").stop()
		get_parent().get_node("AnimatedSprite2D").play("Jump1")
		SignalBus.playSFX.emit("TrissWalk1")
		await get_tree().create_timer(0.5).timeout
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
			apCost = 0
			description = "Pick up an adjacent ally. Re-use to place them down and grant baton pass. 0 AP"
			post_execute()
	else:
		print("EXECUTED 2")
		
		get_parent().get_node("AnimatedSprite2D").stop()
		get_parent().get_node("AnimatedSprite2D").play("Jump1")
		SignalBus.playSFX.emit("TrissWalk2")
		await get_tree().create_timer(0.5).timeout
		
		storedUnit.position = get_parent().grid.map_to_local(clickedPos)
		storedUnit.set_modulate(Color(1,1,1,1))
		storedUnit.set_visible(true)
		storedUnit.give_batonpass()
		
		isCarrying = false
		storedUnit = null
		apCost = 2
		description = "Pick up an adjacent ally. Re-use to place them down and grant baton pass. 2 AP"
		AutoloadMe.allowEndTurn = true
		post_execute2()
