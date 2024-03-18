extends Ability_class

func _enter_tree():
	targetType = get_parent().fac.ENEMY

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED Grapple")
	print(targetUnits)
	
	for i in targetUnits.size():
		targetUnits[i].lose_health(2)
		targetUnits[i].add_passive("Trap")
	
	get_parent().add_passive("Trap")
	get_parent().canMove = false
	
	post_execute()
