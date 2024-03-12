extends Control

func _ready():
	SignalBus.connect("currentUnit", set_ui)
	SignalBus.connect("apUpdate", changeAP)

func set_ui(unit):
	if unit.get_faction() == unit.fac.ALLY:
		var portraitRes = load("res://Assets/Sprites/Allies/" + unit.Name+"/"+unit.Name+"_Base_Still.png")
		get_node("../UI/InfoBox/PortraitBox/Sprite2D").texture = portraitRes
		
		var nameVal = unit.Name
		$InfoBox/Name.set_text(nameVal)
		
		var hpVal = str(unit.get_current_hp()) + " / " + str(unit.get_max_hp())
		$InfoBox/HPValue.set_text(hpVal)
		
		var apVal = str(unit.get_max_ap()) + " / " + str(unit.get_max_ap())
		$InfoBox/APValue.set_text(apVal)

func changeAP(tempAP, maxAP):
	var apVal = str(tempAP) + " / " + str(maxAP)
	$InfoBox/APValue.set_text(apVal)
