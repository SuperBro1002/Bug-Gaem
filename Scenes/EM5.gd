extends event_man

var finalPhase = 1

func _ready():
	AutoloadMe.mapID = 5
	SignalBus.connect("checkEvents", start_round_event_check)
	SignalBus.connect("checkObjective", check_objective)
	SignalBus.connect("finalBattle", phase_two)

func activate_spawners():
	print("CURRENT ROUND: ", AutoloadMe.roundNum)
	if finalPhase == 1:
		match AutoloadMe.roundNum % 3:
			0:
				SignalBus.spawnGroup.emit(1)
	else:
		SignalBus.spawnGroup.emit(2)
		Dialogic.VAR.CutsceneUp = true
		SignalBus.spawnDrone.emit()

func phase_two():
	finalPhase = 2

func check_routed():
	if AutoloadMe.deathCount >= objectiveNum:
		AutoloadMe.set_process_unhandled_input(false)
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://Scenes/Finale.tscn")

func check_boss_routed():
	if AutoloadMe.bossdead == true:
		AutoloadMe.set_process_unhandled_input(false)
		await get_tree().create_timer(3).timeout
		#Update and save level variable
		AutoloadMe.level = 1
		AutoloadMe.save()
		get_tree().change_scene_to_file("res://Scenes/Finale.tscn")

