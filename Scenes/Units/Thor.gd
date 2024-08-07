extends "res://Scripts/enemy.gd"

@export var phase = 1
@export var startPhaseTwo = false
signal ThorAttack
signal abilityFinished
var chloroblastExecuting
var g = 1
var b = 1
var glowDir = true
var glowing = false

func _ready():
	SignalBus.connect("phaseChange", set_phase)

func _process(delta):
	if !glowing:
		await color_change()

func color_change():
	if phase == 1:
		glowing = true
		if glowDir:
			print("Yes")
			g -= 0.05
			b -= 0.05
			if g <= 0.1:
				glowDir = false
		else:
			print("No")
			g += 0.05
			b += 0.05
			if g >= 1:
				glowDir = true
		
		get_node("/root/Garden/FakeThor").set_modulate(Color(1,g,b,1))
		
		await get_tree().create_timer(0.1).timeout
		glowing = false

func on_turn_start():
	AutoloadMe.set_process_unhandled_input(false)
	if isDown: 
		tempAP = 0
		CurrentAP = 0
	if AutoloadMe.passingUnit != null:
		print("BATON PASSED")
		var prevUnit = AutoloadMe.passingUnit
		#inherit_ap(prevUnit.CurrentAP)
		gain_ap(MaxAP/2)
		tempAP = CurrentAP
		#prevUnit.CurrentAP = 0
		#prevUnit.tempAP = 0
		AutoloadMe.passingUnit = null
	
	if Faction == fac.ENEMY:
		SignalBus.showUI.emit()
	
	if phase == 1:
		get_node("/root/Garden/FakeThor/CPUParticles2D").emitting = true
	else:
		start_particle()
	
	tempAP = CurrentAP
	start = grid.local_to_map(position)
	abilityStartPoint = grid.convert_to_map(position)
	SignalBus.updateUI.emit(self)
	SignalBus.startAnimate.emit(self)
	print(self, " ", CurrentAP)
	print("UnitList: ", AutoloadMe.globalUnitList)
	SignalBus.wipeTilePaths.emit(null)
	
	if AutoloadMe.enemyPhase == false:
		await SignalBus.endAnimate
	#else:
		#print("###########TIMERRRRRRRR")
		#await get_tree().create_timer(1).timeout
	
	SignalBus.startTurn.emit()
	SignalBus.changeButtonState.emit()
	run_passives(methodType.ON_TURN_START, null)
	find_and_delete_passives()
	
	grid.update_grid_collision()
	SignalBus.updateUI.emit(self)
	print("	", Name, " turn start.")
	unique_turn_start()

func unique_turn_start():
	chloroblastExecuting = false
	print("PHASE ", phase)
	if phase == 2 and startPhaseTwo == true:
		position = grid.map_to_local(await set_phase())
		startPhaseTwo = false
	await get_tree().create_timer(1).timeout
	
	if CurrentHP <= 0:
		#SignalBus.endTurn.emit()
		on_turn_end()
		return
	
	if phase == 1:
		AutoloadMe.currentAbility = ability1
		run_passives(methodType.ABILITY_EXECUTE, null)
		chloroblastExecuting = true
		get_node("/root/Garden/FakeThor").set_speed_scale(5.0)
		await ability1.enemy_execute(target)
		get_node("/root/Garden/FakeThor").set_speed_scale(1.0)
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
							face_direction(pathArray[i])
							SignalBus.playSFX.emit(str("ParamantisWalk", randi_range(1,3)))
							get_node("AnimatedSprite2D").stop()
							get_node("AnimatedSprite2D").play("Jump1")
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

func on_turn_end():
	if chloroblastExecuting:
		print("IM WAITING")
		await abilityFinished
	print("AND IM GOING")
	run_passives(methodType.ON_TURN_END, null)
	SignalBus.wipeTilePaths.emit(null)
	find_and_delete_passives()
	if BatonPass == TS.BATONPASS:
		BatonPass = storedBatonPass
	else:
		set_has_acted()
	
	canMove = true
	SignalBus.actedUI.emit()
	print("	", Name, " has acted.")
	stop_particle()
	if AutoloadMe.mapID == 3 and phase == 1:
		get_node("/root/Garden/FakeThor/CPUParticles2D").emitting = false
	
	unique_turn_end()


func set_phase():
	collision_layer = 2
	startPhaseTwo = true
	set_visible(true)
	if AutoloadMe.mapID == 3:
		get_node("/root/Garden/FakeThor/CPUParticles2D").emitting = false
		get_node("/root/Garden/FakeThor").set_visible(false)
	#position = grid.map_to_local(Vector2i(9,9))
	phase = 2
	ability1 = load_ability("Fury")
	ability2 = load_ability("Sniper")
	Dialogic.VAR.GardenPhase2 = true
	if AutoloadMe.mapID == 3:
		return Vector2i(9,9)
	else:
		return Vector2i(5,2)

func delete(unit):
	if unit == self:
		print("--------------------I AM DYING---------------------")
		print("Map: ", AutoloadMe.mapID)
		set_visible(false)
		set_collision_layer_value(1,false)
		set_collision_layer_value(2,false)
		AutoloadMe.globalUnitList.erase(unit)
		AutoloadMe.globalEnemyList.erase(unit)
		AutoloadMe.globalAllyList.erase(unit)
		AutoloadMe.globalTargetList.erase(unit)
		AutoloadMe.deathCount += 1
		if AutoloadMe.mapID == 3:
			AutoloadMe.ThorGardenDeath = true
			print("Thor is dead? ", AutoloadMe.ThorGardenDeath)
		if AutoloadMe.mapID == 5:
			SignalBus.finalBattle.emit()
		SignalBus.updateGrid.emit()
		SignalBus.deleteMe.emit(self)
		await get_tree().create_timer(2).timeout
		SignalBus.checkObjective.emit()
		SignalBus.HpUiFinish.emit()
		
		if AutoloadMe.turnPointer == self:
			SignalBus.endTurn.emit()
		queue_free()

func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.get_animation() == "Attack1" and $AnimatedSprite2D.get_frame() == 5:
		$AnimatedSprite2D.pause()
		await ThorAttack
		print("DONE WAITING!!!!!!!")
		$AnimatedSprite2D.play()
