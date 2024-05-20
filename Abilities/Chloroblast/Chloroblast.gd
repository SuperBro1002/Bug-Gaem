extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
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

func enemy_execute(initTarget):
	targetUnits.append(initTarget)
	$Area2D/SelectionBox.set_visible(true)
	if initTarget.position.x > get_parent().position.x:
		$Area2D.position.y -= 64
		$Area2D.set_rotation_degrees(0)
		#print("Right")
	elif initTarget.position.y > get_parent().position.y:
		$Area2D.position.x += 64
		$Area2D.set_rotation_degrees(90)
		#print("Below")
	elif initTarget.position.x < get_parent().position.x:
		$Area2D.position.y += 64
		$Area2D.set_rotation_degrees(180)
		#print("Left")
	elif initTarget.position.y < get_parent().position.y:
		$Area2D.position.x -= 64
		$Area2D.set_rotation_degrees(270)
		#print("Above")

	$Area2D.position = initTarget.position
	await get_tree().create_timer(0.7).timeout
	execute()

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	await get_tree().create_timer(0.1).timeout
	
	face_target()
	#get_parent().get_node("AnimatedSprite2D").stop()
	#get_parent().get_node("AnimatedSprite2D").play("Attack1")
	await get_tree().create_timer(0.7).timeout
	
	for i in targetUnits.size():
		print(targetUnits.size())
		print(targetUnits, " ", i)
		if targetUnits == null:
			return
		#await
		targetUnits[i].lose_health(6)
	post_execute()
