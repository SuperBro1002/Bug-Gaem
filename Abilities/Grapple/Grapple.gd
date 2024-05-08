extends Ability_class

func _enter_tree():
	targetType = [get_parent().fac.ENEMY]
	Name = "Grapple"
	fileName = "Grapple"
	description = "Deals 2 damage to a single target. The attacking unit and the defending unit are both trapped in-place through their next turn. 3 AP"

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
