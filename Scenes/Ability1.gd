extends Button

func _toggled(button_pressed):
	if button_pressed == true:
		SignalBus.ability.emit(1,true)
	else:
		SignalBus.ability.emit(1,false)
