extends Button

var APcost

func _ready():
	SignalBus.connect("abilityExecuted",unpress)
	SignalBus.connect("currentUnit", assign_ap_cost)
	SignalBus.connect("changeButtonState", button_state)

func _toggled(button_pressed):
	if button_pressed == true:
		get_node("../Ability1Button").unpress(null)
		get_node("../Ability3Button").unpress(null)
		SignalBus.ability.emit(2,true)
		SignalBus.showRangeTiles.emit(AutoloadMe.turnPointer.SetAbility2)
	else:
		AutoloadMe.queueState = false
		SignalBus.ability.emit(2,false)
		SignalBus.endRangeTiles.emit()

func unpress(_ability):
	button_pressed = false

#LOOK INTO CURRENT AP AT THIS POINT!!!!!!!!!!!
func button_state():
	if AutoloadMe.turnPointer.get_faction() != AutoloadMe.turnPointer.fac.ALLY or AutoloadMe.turnPointer.get_temp_ap() - APcost < 0 or AutoloadMe.notOverlapped == false:
		self.set_disabled(true)
		if AutoloadMe.turnPointer.get_faction() == AutoloadMe.turnPointer.fac.ALLY:
			AutoloadMe.queueState = false
			SignalBus.ability.emit(1,false)
			button_pressed = false
	else:
		self.set_disabled(false)

func assign_ap_cost(current):
	if current.get_faction() == current.fac.ALLY:
		APcost = current.ability2.get_ap_cost()
