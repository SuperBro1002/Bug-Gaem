extends Ability_class

var occupiedPos = false
var collatUnit
var newPos
var bouncePos
var validTargetPos
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
	collatUnit = null
	validTargetPos = false
	occupiedPos = false
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
		newPos = get_parent().grid.get_global_mouse_position()
		newPos = get_parent().grid.local_to_map(newPos) # Grabs mouse pos and converts it to grid
		for i in targetUnits:
			if newPos == get_parent().grid.local_to_map(i.position):
				return
		clickedDistance = abilityGrid.get_point_path(get_parent().abilityStartPoint,newPos) # Makes a list of the shortest path of tiles between the parent and clickedPos
		print(clickedDistance.size() - 1)
		if clickedDistance.size() - 1 <= 5 and clickedDistance.size() - 1 >= 3 and newPos.x >= 1 and newPos.y >= 1 and newPos.x <= AutoloadMe.gridSize.x - 2 and newPos.y <= AutoloadMe.gridSize.y - 2 and newPos != get_parent().grid.local_to_map(get_parent().position):
			validTargetPos = true
			for i in AutoloadMe.globalTargetList.size() - 1:
				if newPos == AutoloadMe.globalTargetList[i].grid.local_to_map(AutoloadMe.globalTargetList[i].position):
					occupiedPos = true
					collatUnit = AutoloadMe.globalTargetList[i]
					bouncePos = get_parent().grid.flood_fill_first(newPos)
					break
			if AutoloadMe.movementGrid.is_point_solid(newPos) and occupiedPos == false:
				return
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
		await get_tree().create_timer(0.7).timeout
		
		for i in targetUnits.size():
			targetUnits[i].position = get_parent().grid.map_to_local(newPos)
			
			targetUnits[i].abilityStartPoint = targetUnits[i].grid.convert_to_map(newPos) # CHANGE WHEN COLLATERAL MOVEMENT IS ADDED
			
			if occupiedPos == true:
				#Tweens target to the bouncePos
				targetUnits[i].lose_health(4)
				collatUnit.lose_health(4)
				#await get_tree().create_timer(0.5).timeout
				targetUnits[i].position = bouncePos
				targetUnits[i].abilityStartPoint = targetUnits[i].grid.convert_to_map(bouncePos)
			
			targetUnits[i].give_batonpass()
		
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
