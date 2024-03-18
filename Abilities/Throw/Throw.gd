extends Ability_class

func _enter_tree():
	targetType = get_parent().fac.ALLY

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED Throw")
	print(targetUnits)
	
	for i in targetUnits.size():
		targetUnits[i].give_batonpass()
	
	post_execute()
