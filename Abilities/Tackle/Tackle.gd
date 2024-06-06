extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "Robo-Roll"
	fileName = "Tackle"
	description = "Deals 1 damage to an adjacent target. 3 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	await get_tree().create_timer(0.1).timeout
	
	face_target()
	SignalBus.playSFX.emit("RobugAttack1")
	get_parent().get_node("AnimatedSprite2D").stop()
	get_parent().get_node("AnimatedSprite2D").play("Attack1")
	$VFX.position = targetUnits[0].position
	$VFX.position.x -= 50
	$VFX.set_visible(true)
	SignalBus.playSFX.emit("powerflutter")
	$VFX.play("Effect")
	await get_tree().create_timer(0.7).timeout
	
	for i in targetUnits.size():
		if targetUnits == null:
			return
		targetUnits[i].lose_health(1)
	
	$VFX.set_visible(false)
	post_execute()
