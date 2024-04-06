extends Ability_class


func _enter_tree():
	targetType = get_parent().fac.ENEMY
	description = "Deals 4 damage to a single target. If the target dies from this attack, they become possessed, and receive baton pass. They then perish after taking one turn."

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	for i in targetUnits.size():
		if targetUnits[i].get_current_hp() - 4 <= 0:
			var scene = load("res://Scenes/ally.tscn")
			var sceneNode = scene.instantiate()
			get_node("../..").add_child(sceneNode)
			sceneNode.clone(targetUnits[i])
			
			SignalBus.remakeUnitList.emit()
			#await get_tree().create_timer(1).timeout
			targetUnits[i].lose_health(4)
			
	
	post_execute()
