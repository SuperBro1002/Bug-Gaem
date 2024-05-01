extends Ability_class

func _enter_tree():
	targetType = get_parent().fac.ALLY
	Name = "Empower"
	description = "Target's next attack does double damage. 2 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED ", AutoloadMe.currentAbility)
	print(targetUnits)
	
	for i in targetUnits.size():
		targetUnits[i].add_passive("Empowered_Attack")
	
	post_execute()
