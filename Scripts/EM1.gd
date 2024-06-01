extends event_man

func _ready():
	SignalBus.connect("checkEvents", start_round_event_check)
	SignalBus.connect("checkObjective", check_objective)

func activate_spawners():
	match AutoloadMe.roundNum:
		1:
			SignalBus.spawnGroup.emit(1)
		2:
			SignalBus.spawnGroup.emit(2)
		3:
			SignalBus.spawnGroup.emit(3)
		4:
			pass

func check_routed():
	if AutoloadMe.deathCount >= objectiveNum:
		get_node("/root/Main_Controller").free()
		get_tree().change_scene_to_file("res://Scenes/Cathedral 1.tscn")
