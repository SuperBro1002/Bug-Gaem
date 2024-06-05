extends Ability_class

func _enter_tree():
	targetType = [get_parent().fac.ALLY]
	Name = "Rage Boost"
	fileName = "Empower"
	description = "Target's next attack deals double damage. 2 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED ", AutoloadMe.currentAbility)
	print(targetUnits)
	
	face_target()
	get_parent().get_node("AnimatedSprite2D").stop()
	get_parent().get_node("AnimatedSprite2D").play("Cast2")
	await get_tree().create_timer(0.7).timeout
	
	for i in targetUnits.size():
		targetUnits[i].add_passive("Empowered_Attack")
	
	post_execute()
