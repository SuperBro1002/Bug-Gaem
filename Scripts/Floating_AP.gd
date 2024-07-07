extends Control

func _ready():
	SignalBus.connect("updateFloatingAP", update)
	SignalBus.connect("startTurn", show_me)
	SignalBus.connect("endTurn", hide_me)
	get_parent().connect("displayAP", toggle_ap)

func toggle_ap(state):
	if state == false:
		set_visible(false)
	else:
		set_visible(true)

func show_me():
	if get_parent() != AutoloadMe.turnPointer or AutoloadMe.turnPointer.get_faction() == AutoloadMe.turnPointer.fac.ENEMY:
		return
	set_visible(true)

func hide_me():
	if get_parent() != AutoloadMe.turnPointer or (get_parent().isPossessed == true and get_parent() == AutoloadMe.turnPointer):
		return
	set_visible(false)

func update(val):
	if get_parent() != AutoloadMe.turnPointer:
		return
	else:
		$AP_Counter.set_text(str(val))
	
	if val == get_parent().get_max_ap():
		set_modulate(Color(0,1,1,1))
	elif val == 0:
		set_modulate(Color(1,0,0,1))
	else:
		set_modulate(Color(1,1,1,1))
