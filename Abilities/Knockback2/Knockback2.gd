extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "Ironclad Shove"
	fileName = "Knockback2"
	description = "Deals 6 damage to an adjacent target and pushes them 1 tile away. 7 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	face_target()
	get_parent().get_node("AnimatedSprite2D").stop()
	get_parent().get_node("AnimatedSprite2D").play("Attack1")
	SignalBus.playSFX.emit("SacrificialSting")
	await get_tree().create_timer(0.7).timeout
	
	for i in targetUnits.size():
		if targetUnits == null:
			return
		targetUnits[i].lose_health(6)
		var pushDirection = targetUnits[i].position - get_parent().position
		var targetPos = targetUnits[i].position + pushDirection
		for j in AutoloadMe.globalTargetList.size():
			if targetPos == AutoloadMe.globalTargetList[j].position or AutoloadMe.movementGrid.is_point_solid(get_parent().grid.local_to_map(targetPos)):
				post_execute()
				return
		targetUnits[i].position = targetPos
	post_execute()
