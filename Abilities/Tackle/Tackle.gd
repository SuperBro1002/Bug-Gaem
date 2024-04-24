extends Ability_class


func _enter_tree():
	targetType = get_parent().fac.ENEMY
	Name = "Tackle"
	description = "Deals 2 damage to a single target. 4 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	for i in targetUnits.size():
		if targetUnits == null:
			return
		targetUnits[i].lose_health(2)
	
	post_execute()
