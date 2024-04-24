extends Ability_class


func _enter_tree():
	targetType = get_parent().fac.ALLY
	Name = "Shield"
	description = "Grants an adjacent ally a shield that reduces damage from the next attack against them by 1. 4 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	for i in targetUnits.size():
		targetUnits[i].add_passive("Armor")
	
	post_execute()
