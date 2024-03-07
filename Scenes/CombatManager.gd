extends Node

func _ready():
	SignalBus.connect("ability",toggle_unit_ability)

func toggle_unit_ability(num, state):
	if state == true:
		AutoloadMe.turnPointer.activate_ability(num)
	else:
		AutoloadMe.turnPointer.deactivate_ability()
