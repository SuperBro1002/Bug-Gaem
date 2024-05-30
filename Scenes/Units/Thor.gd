extends "res://Scripts/enemy.gd"

var phase = 1

func _ready():
	SignalBus.connect("phaseChange", set_phase)

func unique_turn_start():
	print("PHASE ", phase)
	if phase == 2:
		set_phase()
	await get_tree().create_timer(2).timeout
	
	if phase == 1:
		AutoloadMe.currentAbility = ability1
		run_passives(methodType.ABILITY_EXECUTE, null)
		await ability1.enemy_execute(target)
		CurrentAP -= ability1.get_ap_cost()
		
		await get_tree().create_timer(1).timeout
	else:
		shortestPath = 10000
		lengthList = [] # List of distances to different opposing units
		target = null
		grid.set_enemy_collision()
		for i in AutoloadMe.globalAllyList.size():
			end = grid.local_to_map(AutoloadMe.globalAllyList[i].position)
			lengthList.append(AutoloadMe.movementGrid.get_point_path(start, end).size())
		
		# Determines the closest unit
		for i in lengthList.size():
			print(lengthList[i])
			if lengthList[i] < shortestPath:
				shortestPath = lengthList[i]
				target = AutoloadMe.globalAllyList[i]
		if shortestPath <= aggroRange + 1 and shortestPath > 0:
			end = grid.local_to_map(target.position)
			
			var pathArray
			
			if canMove == true:
				if position.x != target.position.x and position.y != target.position.y:
					# Determines the coordinate that will be used to align with target on an axis.
					var vectorDiff = abs(position - target.position)
					var alignPos
					if vectorDiff.x <= vectorDiff.y:
						alignPos = Vector2(target.position.x, position.y)
					else:
						alignPos = Vector2(position.x, target.position.y)
					
					end = grid.local_to_map(alignPos)
					pathArray = AutoloadMe.movementGrid.get_point_path(start, end)
					print("Start: ", start, " End: ", end)
					print("CLOSEST DUDE IS ", target, ": ", pathArray)
					
					for i in pathArray.size():
						if CurrentAP != 0 and i > 0:
							CurrentAP -= 1
							var tween = create_tween()
							print(pathArray[i])
							tween.tween_property(self, "position", pathArray[i], 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)
							await tween.finished
				else:
					print("ALREADY ALIGNED")
				
				start = grid.local_to_map(position)
				#pathArray = AutoloadMe.movementGrid.get_point_path(start, end)
			
			# Uses Fury if aligned with target on an axis and has AP.
			if position.x == target.position.x or position.y == target.position.y:
				if CurrentAP >= ability1.get_ap_cost():
					grid.set_wall_collision()
					AutoloadMe.currentAbility = ability1
					run_passives(methodType.ABILITY_EXECUTE, null)
					await ability1.enemy_execute(target)
					CurrentAP -= ability1.get_ap_cost()
					print("after ability")
					#await get_tree().create_timer(1).timeout
					##await SignalBus.HpUiFinish
					print("After signal")
					await get_tree().create_timer(1).timeout
					# NOTE: MAY NEED TO TWEAK WHEN MORE ANIMATIONS ADDED
			else:
				print("Short path ", shortestPath)
				if CurrentAP >= ability2.get_ap_cost():
					AutoloadMe.currentAbility = ability2
					run_passives(methodType.ABILITY_EXECUTE, null)
					await ability2.enemy_execute(target)
					CurrentAP -= ability2.get_ap_cost()
					await get_tree().create_timer(1).timeout
	
	on_turn_end()

func set_phase():
	phase = 2
	ability1 = load_ability("Fury")
	ability2 = load_ability("Sniper")
