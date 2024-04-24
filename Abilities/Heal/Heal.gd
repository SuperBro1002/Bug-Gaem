extends Ability_class


func _enter_tree():
	targetType = get_parent().fac.ALLY
	Name = "Heal"
	description = "Heals an adjacent ally for 2 health. 3 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	for i in targetUnits.size():
		targetUnits[i].gain_health(2)
	
	post_execute()
