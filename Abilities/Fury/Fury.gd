extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "Fury Skewer"
	fileName = "Fury"
	description = "Thor'axe dashes 9 spaces forward, damaging anyone in his path. 9 AP"

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
		targetUnits[i].lose_health(2)
	post_execute()
