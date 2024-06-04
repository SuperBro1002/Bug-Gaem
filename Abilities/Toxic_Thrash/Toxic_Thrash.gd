extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "Toxic Thrash"
	fileName = "Toxic_Thrash"
	description = "Deals 2 damage and inflicts poison to an adjacent target. 2 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	face_target()
	get_parent().get_node("AnimatedSprite2D").stop()
	get_parent().get_node("AnimatedSprite2D").play("Attack1")
	
	$VFX.position = targetUnits[0].position
	
	if target_is_right():
		$VFX.set_flip_h(false)
		$VFX.position.x -= 60
	else:
		$VFX.set_flip_h(true)
		$VFX.position.x += 60
	
	$VFX.set_visible(true)
	$VFX.play("Effect")
	await get_tree().create_timer(0.7).timeout
	
	for i in targetUnits.size():
		targetUnits[i].lose_health(2)
		targetUnits[i].add_passive("Poison")
	
	$VFX.set_visible(false)
	post_execute()
