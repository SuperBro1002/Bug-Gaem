extends Ability_class

var sceneNode

func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "X-Slash"
	description = "Deals 3 damage to a single enemy and grants baton pass. If the target dies from this attack, they become possessed, and receive baton pass. They then perish after taking one turn. 3 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	for i in targetUnits.size():
		if targetUnits[i].get_current_hp() - 3 <= 0 and targetUnits[i].Faction != get_parent().fac.OBSTACLE:
			var scene = load("res://Scenes/ally.tscn")
			sceneNode = scene.instantiate()
			get_node("../..").add_child(sceneNode)
			sceneNode.clone(targetUnits[i])
			
			SignalBus.addToUnitList.emit(sceneNode)
			#SignalBus.remakeUnitList.emit()
			#await get_tree().create_timer(1).timeout
		else:
			targetUnits[i].give_batonpass()
		targetUnits[i].lose_health(3)
	
	post_execute()
