extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "Toxic Thrash"
	fileName = "Toxic_Thrash"
	description = "Deals 2 damage and inflicts poison to a single target. 2 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	for i in targetUnits.size():
		targetUnits[i].lose_health(2)
		targetUnits[i].add_passive("poison")
	
	post_execute()
