extends Ability_class

var corner = 1

func _enter_tree():
	targetType = [get_parent().fac.ALLY, get_parent().fac.OBSTACLE]
	$Area2D.set_rotation_degrees(180)
	Name = "Chloroblast"
	fileName = "Chloroblast"
	description = "Thor'axe throws an axe 9 tiles diagonally dealing 6 damage to targets. 11 AP"

#func rotate(initTarget):
	#await get_tree().create_timer(1).timeout
	#initTarget = get_parent().grid.map_to_local(initTarget)
	#if initTarget.x > get_parent().position.x:
		#$Area2D.position.y -= 64
		#$Area2D.set_rotation_degrees(0)
		#print("Right")
	#elif initTarget.x < get_parent().position.x:
		#$Area2D.position.y += 64
		#$Area2D.set_rotation_degrees(180)
		#print("Left")
	#elif initTarget.y < get_parent().position.y:
		#$Area2D.position.x -= 64
		#$Area2D.set_rotation_degrees(270)
		#print("Above")
	#elif initTarget.y > get_parent().position.y:
		#$Area2D.position.x += 64
		#$Area2D.set_rotation_degrees(90)
		#print("Below")

func enemy_execute(_initTarget):
	$Area2D/SelectionBox.set_visible(true)
	match corner:
		1:
			$Area2D.position = get_parent().grid.map_to_local(Vector2i(8,9))
		2:
			$Area2D.position = get_parent().grid.map_to_local(Vector2i(8,8))
		3:
			$Area2D.position = get_parent().grid.map_to_local(Vector2i(9,8))
		4:
			$Area2D.position = get_parent().grid.map_to_local(Vector2i(9,9))
	
	print("ENEMY EXECUTE RUN")
	SignalBus.playSFX.emit("PassingDanger")
	await get_tree().create_timer(0.7).timeout
	execute()
	$Area2D/SelectionBox.set_visible(false)
	corner += 1
	if corner > 4:
		corner = 1

func post_execute():
	dmgMod = 1
	targetUnits.clear()
	get_parent().grid.update_grid_collision()
	SignalBus.abilityExecuted.emit(self)
	SignalBus.updateUI.emit(get_parent())
	AutoloadMe.isExecuting = false
	SignalBus.changeControls.emit()
	AutoloadMe.set_process_unhandled_input(true)
	$Area2D.rotation_degrees += 90
	if get_parent().Faction == get_parent().fac.ALLY:
		SignalBus.changeButtonState.emit()
	elif get_parent().Faction == get_parent().fac.ENEMY:
		dequeue(1,false)

#func enemy_execute(initTarget):
	#targetUnits.append(initTarget)
	#$Area2D/SelectionBox.set_visible(true)
	#if initTarget.position.x > get_parent().position.x:
		#$Area2D.position.y -= 64
		#$Area2D.set_rotation_degrees(0)
		##print("Right")
	#elif initTarget.position.y > get_parent().position.y:
		#$Area2D.position.x += 64
		#$Area2D.set_rotation_degrees(90)
		##print("Below")
	#elif initTarget.position.x < get_parent().position.x:
		#$Area2D.position.y += 64
		#$Area2D.set_rotation_degrees(180)
		##print("Left")
	#elif initTarget.position.y < get_parent().position.y:
		#$Area2D.position.x -= 64
		#$Area2D.set_rotation_degrees(270)
		##print("Above")
	#
	#$Area2D.position = initTarget.position
	#await get_tree().create_timer(0.7).timeout
	#execute()

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED CHLOROBLAST")
	print(targetUnits)
	
	await get_tree().create_timer(0.1).timeout
	
	#face_target()
	#get_parent().get_node("AnimatedSprite2D").stop()
	#get_parent().get_node("AnimatedSprite2D").play("Attack1")
	await get_tree().create_timer(0.7).timeout
	if targetUnits == null:
		post_execute()
	for i in targetUnits.size():
		print(targetUnits.size())
		print(targetUnits, " ", i)
		if targetUnits == null:
			return
		await targetUnits[i].lose_health(6)
	
	post_execute()
