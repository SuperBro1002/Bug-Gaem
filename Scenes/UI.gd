extends Control

func _ready():
	SignalBus.connect("currentUnit", set_ui)
	SignalBus.connect("updateUI", set_ui)

func set_ui(unit):
	if unit.get_faction() == unit.fac.ALLY:
		var portraitRes = load("res://Assets/Sprites/Allies/" + unit.Name+"/"+unit.Name+"_Base_Still.png")
		get_node("../UI/InfoBox/PortraitBox/Sprite2D").texture = portraitRes
		
		var nameVal = unit.Name
		$InfoBox/Name.set_text(nameVal)
		
		var hpVal = str(unit.get_current_hp()) + " / " + str(unit.get_max_hp())
		$InfoBox/HPValue.set_text(hpVal)
		print("hp:", unit.get_temp_ap())
		print("RUNNING")
		var apVal = str(unit.get_temp_ap()) + " / " + str(unit.get_max_ap())
		$InfoBox/APValue.set_text(apVal)