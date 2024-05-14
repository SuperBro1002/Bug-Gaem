extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "Flail"
	fileName = "Tackle"
	description = "Deals 1 damage to a single target. 5 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	for i in targetUnits.size():
		if targetUnits == null:
			return
		targetUnits[i].lose_health(1)
	
	post_execute()
