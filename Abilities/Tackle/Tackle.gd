extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "Flail"
	fileName = "Tackle"
	description = "Deals 1 damage to a single target. 5 AP"

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
		if targetUnits == null:
			return
		targetUnits[i].lose_health(1)
	
	post_execute()
