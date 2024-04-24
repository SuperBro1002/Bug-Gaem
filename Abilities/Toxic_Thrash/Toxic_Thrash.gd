extends Ability_class


func _enter_tree():
	targetType = get_parent().fac.ENEMY
	description = "Deals 2 damage and inflicts poison to a single target."

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	for i in targetUnits.size():
		targetUnits[i].lose_health(2)
		targetUnits[i].add_passive("poison")
	
	post_execute()
