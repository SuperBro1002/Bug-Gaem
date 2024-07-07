extends Ability_class

var occupiedPos = false
var collatUnit
var newPos
var bouncePos
var validTargetPos = false
var secondRange = 1

func _enter_tree():
	$Area2D2/SelectionBox.set_visible(false)
	targetType = [get_parent().fac.ALLY]
	Name = "Horn Catapult"
	fileName = "Throw"
	description = "Select an adjacent unit to throw to a nearby space. Unit being thrown gains Baton Pass. If there is a unit in the target's new space, both take 4 damage and the former is pushed off the tile. 6 AP"

func queue():
	secondRange = 1
	AutoloadMe.currentAbility = self
	if AutoloadMe.validQueue == false:
		if get_parent().get_temp_ap() - apCost >= 0: # Checks if parent has enough AP
			clickedPos = get_parent().grid.get_global_mouse_position()
			clickedPos = get_parent().grid.local_to_map(clickedPos) # Grabs mouse pos and converts it to grid
			clickedDistance = abilityGrid.get_point_path(get_parent().abilityStartPoint,clickedPos) # Makes a list of the shortest path of tiles between the parent and clickedPos
			
			for i in AutoloadMe.globalUnitList.size() - 1:
				if clickedPos == AutoloadMe.globalUnitList[i].grid.local_to_map(AutoloadMe.globalUnitList[i].position) and clickedPos != get_parent().grid.local_to_map(get_parent().position) and AutoloadMe.globalUnitList[i].Faction != get_parent().fac.OBSTACLE: # Checks if a unit is present at clickedPos
					if clickedDistance.size() - 1 <= distanceRange: # Checks if ClickedPos is within the ability's designated tile range and is the proper alignment
						$Area2D.position = get_parent().grid.map_to_local(clickedPos) # Moves the collision box to clickedPos. If any unit is within this box, they are added to a targetList
						$Area2D/SelectionBox.set_visible(true)
						kill_range_tiles()
						secondRange = 5
						draw_range_tiles2(Name)
						print("DUMB")
						await get_tree().create_timer(0.1).timeout
						if !targetUnits.is_empty(): # Checks if a target is found and signals if the game can allow an input to trigger the execute method
							SignalBus.activelyQueueing.emit(true)
						else:
							SignalBus.activelyQueueing.emit(false)
						print(targetUnits)
	else:
		var tempPos = get_parent().grid.local_to_map(get_parent().grid.get_global_mouse_position())
		clickedDistance = abilityGrid.get_point_path(get_parent().abilityStartPoint,tempPos) # Makes a list of the shortest path of tiles between the parent and clickedPos
		if clickedDistance.size() - 1 <= 5 and clickedDistance.size() - 1 >= 3 and tempPos.x >= 1 and tempPos.y >= 1 and tempPos.x <= AutoloadMe.gridSize.x - 2 and tempPos.y <= AutoloadMe.gridSize.y - 2:
			for i in AutoloadMe.globalTargetList.size() - 1:
				if tempPos == AutoloadMe.globalTargetList[i].grid.local_to_map(AutoloadMe.globalTargetList[i].position):
					occupiedPos = true
					collatUnit = AutoloadMe.globalTargetList[i]
					bouncePos = get_parent().grid.flood_fill_first(tempPos)
					break
			if AutoloadMe.movementGrid.is_point_solid(tempPos) and occupiedPos == false:
				return
			newPos = tempPos
			validTargetPos = true
			$Area2D2.position = get_parent().grid.map_to_local(newPos)
			$Area2D2/SelectionBox.set_visible(true)	
	# Store mouse position after left click
	# Find the shortest path between parent and target position
	# Check if its in range
	# Check if target position is occupied
	# If occupied, find an the nearest open tile and note it for damage later
	# Move target to target position

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
	#await get_tree().create_timer(1).timeout
	AutoloadMe.passingUnit = get_parent()
	#get_parent().on_turn_end()

func execute():
	if newPos != null and validTargetPos == true:
		print("EXECUTED Throw")
		print(targetUnits)
		AutoloadMe.passingUnit = get_parent()
		
		face_target()
		SignalBus.playSFX.emit("Throw")
		get_parent().get_node("AnimatedSprite2D").stop()
		get_parent().get_node("AnimatedSprite2D").play("Cast1")
		await get_tree().create_timer(0.1).timeout
		
		for i in targetUnits.size():
			var thrownUnit = targetUnits[i]
			thrownUnit.set_z_index(2)
			
			thrownUnit.throw_up_tween()
			
			await get_tree().create_timer(1).timeout
			thrownUnit.position = get_parent().grid.map_to_local(newPos)
			
			thrownUnit.abilityStartPoint = thrownUnit.grid.convert_to_map(newPos) # CHANGE WHEN COLLATERAL MOVEMENT IS ADDED
			await thrownUnit.throw_down_tween()
			
			if occupiedPos == true:
				#Tweens target to the bouncePos
				var moveTween = create_tween()
				thrownUnit.spin_me(2)
				SignalBus.playSFX.emit("Sting")
				thrownUnit.lose_health(4)
				collatUnit.lose_health(4)
				#await get_tree().create_timer(0.5).timeout
				thrownUnit.abilityStartPoint = thrownUnit.grid.convert_to_map(bouncePos)
				moveTween.tween_property(thrownUnit, "position", bouncePos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				thrownUnit.displayHP.emit(true)
				#thrownUnit.position = bouncePos
				await moveTween.finished
			
			if is_instance_valid(thrownUnit):
				thrownUnit.set_z_index(1)
				thrownUnit.enable_collision()
				thrownUnit.give_batonpass()
		
		post_execute()
	else:
		AutoloadMe.isExecuting = false
		AutoloadMe.set_process_unhandled_input(true)

func draw_range_tiles(activeName):
	if fileName != activeName:
		return
	SignalBus.playSFX.emit("Queue")
	print("Children: ", )
	if get_parent() == AutoloadMe.turnPointer:
		print(get_parent())
		var tiles = get_parent().grid.flood_fill_in_range(get_parent().position, secondRange)
		tiles = get_parent().grid.remove_solid(tiles)
		var sceneNode 
		print("TILES: ", tiles)
		for i in tiles.size():
			var scene = load("res://Scenes/Ability_Tile.tscn")
			sceneNode = scene.instantiate()
			$AbilityRanges.add_child(sceneNode)
			sceneNode.position = tiles[i]
		#kill_range_tiles()

func draw_range_tiles2(activeName):
	if Name != activeName:
		return
	if get_parent() == AutoloadMe.turnPointer:
		print(get_parent())
		var tiles = get_parent().grid.flood_fill_in_range(get_parent().position, secondRange)
		tiles = get_parent().grid.remove_solid_throw(tiles, get_parent().position)
		var sceneNode 
		print("TILES: ", tiles)
		for i in tiles.size():
			var scene = load("res://Scenes/Ability_Tile.tscn")
			sceneNode = scene.instantiate()
			$AbilityRanges.add_child(sceneNode)
			sceneNode.position = tiles[i]
		#kill_range_tiles()

func dequeue(_num, state):
	if state == false:
		validTargetPos = false
		occupiedPos = false
		collatUnit = null
		secondRange = 1
		clickedPos = null
		AutoloadMe.isExecuting = false
		newPos = null
		$Area2D/SelectionBox.set_visible(false)
		$Area2D.position = Vector2(-900,-900)
		$Area2D2/SelectionBox.set_visible(false)
		$Area2D2.position = Vector2(-900,-900)
		kill_range_tiles()

func _on_area_2d_area_entered(area):
	if area.areaType != "spawner":
		targetUnits.append(area)
