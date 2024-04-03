extends Ability_class


func _enter_tree():
	targetType = get_parent().fac.ENEMY
	description = "Deals 4 damage to an adjacent target and 1 damage to self."

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	for i in targetUnits.size():
		targetUnits[i].lose_health(4)
		get_parent().lose_health(1)
	
	post_execute()
