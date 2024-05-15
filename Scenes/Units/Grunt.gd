extends "res://Scripts/enemy.gd"

func unique_turn_start():
	shortestPath = 10000
	lengthList = [] # List of distances to different opposing units
	target = null
	grid.set_enemy_collision()
	
	await get_tree().create_timer(2).timeout
	
	for i in AutoloadMe.globalAllyList.size():
		end = grid.local_to_map(AutoloadMe.globalAllyList[i].position)
		lengthList.append(AutoloadMe.movementGrid.get_point_path(start, end).size())
	
	# Determines the closest unit
	for i in lengthList.size():
		if lengthList[i] < shortestPath:
			shortestPath = lengthList[i]
			target = AutoloadMe.globalAllyList[i]
	
	if shortestPath <= aggroRange + 1:
		end = grid.local_to_map(target.position)
		
		var pathArray = AutoloadMe.movementGrid.get_point_path(start, end)
		
		if canMove == true:
			for i in pathArray.size() - 1:
				if CurrentAP != 0 and i > 0:
					CurrentAP -= 1
					var tween = create_tween()
					tween.tween_property(self, "position", pathArray[i], 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)
					await tween.finished
		
		pathArray = AutoloadMe.movementGrid.get_point_path(grid.local_to_map(position), end)
		
		while CurrentAP >= ability1.get_ap_cost() and pathArray.size() <= 2:
			AutoloadMe.currentAbility = ability1
			run_passives(methodType.ABILITY_EXECUTE, null)
			await ability1.enemy_execute(target)
			CurrentAP -= ability1.get_ap_cost()
			
			#await get_tree().create_timer(1).timeout
			await SignalBus.HpUiFinish
			await get_tree().create_timer(1).timeout
			# NOTE: MAY NEED TO TWEAK WHEN MORE ANIMATIONS ADDED
	else:
		print("Short path ", shortestPath)
	
	on_turn_end()
