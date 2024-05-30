extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "Sniper Stinger"
	fileName = "Sniper"
	description = "Deals 4 damage to a target within 9 tiles. 10 AP"

func enemy_execute(initTarget):
	targetUnits.append(initTarget)
	
	
	await get_tree().create_timer(0.7).timeout
	await execute()

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	await get_tree().create_timer(0.1).timeout
	
	face_target()
	get_parent().get_node("AnimatedSprite2D").stop()
	get_parent().get_node("AnimatedSprite2D").play("Attack1")
	$VFX.set_visible(true)
	$VFX.position = targetUnits[0].position
	$VFX.position.x -= 50
	$VFX.play("Effect")
	await get_tree().create_timer(0.7).timeout
	
	for i in targetUnits.size():
		print(targetUnits.size())
		print(targetUnits, " ", i)
		if targetUnits == null:
			return
		
		targetUnits[i].lose_health(4)
	
	post_execute()
