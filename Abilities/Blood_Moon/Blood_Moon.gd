extends Ability_class


func _enter_tree():
	targetType = get_parent().fac.ENEMY
	Name = "Blood Moon"
	description = "Deals 1 damage to a single target and temporarily increases Heal's effects by 1 HP. 4 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	get_parent().run_passives(get_parent().methodType.ON_TURN_START, null)
	
	for i in targetUnits.size():
		if targetUnits == null:
			return
		targetUnits[i].lose_health(1)
		get_parent().add_passive("Empowered_Heal")
	
	post_execute()
