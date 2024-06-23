extends event_man

func _ready():
	AutoloadMe.mapID = 2
	SignalBus.connect("checkEvents", start_round_event_check)
	SignalBus.connect("checkObjective", check_objective)

func activate_spawners():
	match AutoloadMe.roundNum:
		2:
			pass#SignalBus.spawnGroup.emit(0)
		3:
			pass
		4:
			pass

func check_routed():
	if AutoloadMe.deathCount >= objectiveNum:
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://Scenes/garden.tscn")
