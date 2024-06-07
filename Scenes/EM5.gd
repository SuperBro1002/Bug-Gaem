extends event_man

var finalPhase = 1

func _ready():
	AutoloadMe.mapID = 5
	SignalBus.connect("checkEvents", start_round_event_check)
	SignalBus.connect("checkObjective", check_objective)
	SignalBus.connect("finalBattle", phase_two)

func start_round_event_check():
	print("EVENTS")
	check_objective()
	main_round_events()
	global_side_round_events()
	local_side_round_events()
	
	activate_spawners()

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
		await get_tree().create_timer(1).timeout
		get_tree().quit()

func check_boss_routed():
	if AutoloadMe.bossdead == true:
		get_tree().quit()

