extends Button

func _ready():
	SignalBus.connect("abilityExecuted",unpress)

func _toggled(button_pressed):
	if button_pressed == true:
		SignalBus.ability.emit(1,true)
	else:
		SignalBus.ability.emit(1,false)

func unpress():
	button_pressed = false
