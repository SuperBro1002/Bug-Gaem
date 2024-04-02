extends Ability_class

func _enter_tree():
	targetType = get_parent().fac.ALLY
	description = "Select an adjacent unit to throw to a space within X tiles. If there is a unit in the target's new space, both units take Y damage and the former is pushed off the tile. Unit being thrown gains Baton Pass."

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED Throw")
	print(targetUnits)
	
	for i in targetUnits.size():
		targetUnits[i].give_batonpass()
	
	post_execute()
