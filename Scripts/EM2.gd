extends event_man

func _ready():
	SignalBus.connect("checkEvents", start_round_event_check)

func activate_spawners():
	match AutoloadMe.roundNum:
		2:
			SignalBus.spawnGroup.emit(0)
		3:
			pass
		4:
			pass
