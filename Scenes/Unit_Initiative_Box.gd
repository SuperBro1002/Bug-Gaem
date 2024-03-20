extends Control

var myUnit

func _ready():
	SignalBus.connect("deleteInitObject", remove_me)
	SignalBus.connect("deleteMe", death)

func assign_unit(unit):
	myUnit = unit
	var spritePath = load("res://Assets/HUD/Init_Sprites/" + myUnit.fileName + "_Base_Still.png")
	get_node("Sprite2D").texture = spritePath
	update_display()
	#print("UIIIIIIIIIIIIIII ", get_node("Sprite2D"))

func update_display():
	var hpVal = str(myUnit.get_current_hp()) + " / " + str(myUnit.get_max_hp())
	$hpField.set_text("HP: " + hpVal)
	
	var apVal = str(myUnit.get_current_ap()) + " / " + str(myUnit.get_max_ap())
	$apField.set_text("AP: " + apVal)


func set_colors():
	if myUnit.get_batonpass() == myUnit.TS.ACTED:
		set_modulate(Color(0.42, 0.42, 0.42))
	else:
		set_modulate(Color(1,1,1))
	

func remove_me():
	queue_free()

func death(toBeDeleted):
	if toBeDeleted == myUnit:
		if myUnit.Faction == myUnit.fac.ENEMY:
			AutoloadMe.globalUnitList.erase(myUnit)
			if myUnit.Faction == myUnit.fac.ALLY:
				AutoloadMe.globalAllyList.erase(myUnit)
			else:
				AutoloadMe.globalEnemyList.erase(myUnit)
			
			get_parent().get_parent().get_parent().nodeList = []
			SignalBus.updateInitBox.emit()
			SignalBus.updateGrid.emit()
			myUnit.queue_free()
			queue_free()
