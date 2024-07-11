extends event_man

var begunTwo = false

func _ready():
	AutoloadMe.mapID = 3
	SignalBus.connect("checkEvents", start_round_event_check)
	SignalBus.connect("checkObjective", check_objective)
	SignalBus.connect("midObjective", checkSiphons)

func activate_spawners():
	match AutoloadMe.roundNum:
		2:
			pass#SignalBus.spawnGroup.emit(0)
		3:
			pass
		4:
			pass

func checkSiphons():
	if AutoloadMe.siphonsDestroyed == 4 and begunTwo == false:
		begunTwo = true
		SignalBus.phaseChange.emit()

func check_routed():
	print("--Checking objective--")
	if AutoloadMe.ThorGardenDeath:
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://Scenes/Cathedral 2.tscn")
