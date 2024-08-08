extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "Horn Thrust"
	fileName = "Knockback"
	description = "Deals 2 damage to an adjacent target and pushes them 1 tile away. 4 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	face_target()
	get_parent().get_node("AnimatedSprite2D").stop()
	SignalBus.playSFX.emit("Knockback")
	get_parent().get_node("AnimatedSprite2D").play("Attack1")
	await get_tree().create_timer(0.7).timeout
	
	for i in targetUnits.size():
		if targetUnits == null:
			return
		await targetUnits[i].lose_health(2)
		if !targetUnits.is_empty():
			var pushDirection = targetUnits[i].position - get_parent().position
			var targetPos = targetUnits[i].position + pushDirection
			SignalBus.playSFX.emit("Crash2")
			for j in AutoloadMe.globalTargetList.size():
				if targetPos == AutoloadMe.globalTargetList[j].position or AutoloadMe.movementGrid.is_point_solid(get_parent().grid.local_to_map(targetPos)):
					post_execute()
					return
			var tween = create_tween()
			tween.tween_property(targetUnits[i], "position", targetPos, 0.25).set_trans(Tween.TRANS_SINE)
			#targetUnits[i].position = targetPos
	post_execute()
