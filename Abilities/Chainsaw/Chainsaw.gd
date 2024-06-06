extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "Chain Boom"
	fileName = "Chainsaw"
	description = "Deals 2 damage to targets in a 4-tile line in front of the user. 5 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	await get_tree().create_timer(0.1).timeout
	
	face_target()
	get_parent().get_node("AnimatedSprite2D").stop()
	get_parent().get_node("AnimatedSprite2D").play("Attack1")
	
	for i in targetUnits.size():
		$VFX.position = targetUnits[i].position
		$VFX.position.x -= 50
		$VFX.set_visible(true)
		SignalBus.playSFX.emit("powerflutter")
		$VFX.play("Effect")
		await get_tree().create_timer(0.7).timeout
		print(targetUnits.size())
		print(targetUnits, " ", i)
		if targetUnits == null:
			return
		targetUnits[i].lose_health(2)
		$VFX.set_visible(false)
	
	post_execute()
