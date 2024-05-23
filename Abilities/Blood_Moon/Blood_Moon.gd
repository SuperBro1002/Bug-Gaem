extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "Blood Moon"
	fileName = "Blood_Moon"
	description = "Deals 1 damage to a single target and temporarily increases Heal's effects by 1 HP. 4 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	#get_parent().run_passives(get_parent().methodType.ON_TURN_START, null)
	face_target()
	get_parent().get_node("AnimatedSprite2D").stop()
	get_parent().get_node("AnimatedSprite2D").play("Attack1")
	$VFX.position = targetUnits[0].position
	$VFX.position.x -= 65
	$VFX.set_visible(true)
	$VFX.play("Effect")
	await get_tree().create_timer(0.3).timeout
	$VFX.set_visible(false)
	
	for i in targetUnits.size():
		if targetUnits == null:
			return
		targetUnits[i].lose_health(1)
		get_parent().add_passive("Empowered_Heal")
	
	post_execute()
