extends Ability_class


func _enter_tree():
	SignalBus.connect("abilityIsQueued", queue)
	targetType = get_parent().fac.ENEMY
	description = "Draws all enemies 2 tiles closer to this unit."

func queue():
	if !AutoloadMe.globalEnemyList.is_empty():
		targetUnits = AutoloadMe.globalEnemyList.duplicate()
		SignalBus.activelyQueueing.emit(true)

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(AutoloadMe.globalAllyList)
	
	# LOOK INTO USING BELOW AS ENEMY'S ASTAR FUNCTION MIGHT FIX THE ISSUE OF SOLID UNITS NOT BEING PATH-FINDABLE TO
	
	for i in targetUnits.size():
		targetUnits[i].start = targetUnits[i].grid.local_to_map(targetUnits[i].position)
		targetUnits[i].end = targetUnits[i].grid.local_to_map(get_parent().position)
		targetUnits[i].grid.set_enemy_collision()
		
		for p in AutoloadMe.globalAllyList.size():
			if AutoloadMe.globalAllyList[p] != get_parent():
				var tilePos = AutoloadMe.globalAllyList[p].grid.local_to_map(AutoloadMe.globalAllyList[p].position)
				AutoloadMe.movementGrid.set_point_solid(tilePos, true)
		
		var pathArray = targetUnits[i].astarGrid.get_point_path(targetUnits[i].start, targetUnits[i].end)
		
		if pathArray.size() > 2:
			pathArray.resize(4)
		
		for j in pathArray.size() - 1:
			if pathArray[j] != get_parent().position :
				var tween = create_tween()
				tween.tween_property(targetUnits[i], "position", pathArray[j], 1.0 / targetUnits[i].animationSpeed).set_trans(Tween.TRANS_SINE)
				await tween.finished
		AutoloadMe.movementGrid.update()
	
	post_execute()
