extends Control

var myUnit

func _ready():
	SignalBus.connect("deleteInitObject", remove_me)
	SignalBus.connect("deleteMe", death)

func assign_unit(unit):
	myUnit = unit
	var spritePath = load("res://Assets/HUD/Init_Sprites/" + myUnit.fileName + "_Base_Still.png")
	get_node("Sprite2D").texture = spritePath
	if unit.get_faction() == unit.fac.ENEMY:
		$affilBox.set_color(Color(1,0.1,0.2,1,))
	update_display()

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
	# Removes unit from UnitLists so it won't be added to InitBox
	if toBeDeleted == myUnit:
		if myUnit.Faction == myUnit.fac.ENEMY: #TEMP IF STATEMENT TO PREVENT ALLIES FROM BEING ERASED
			AutoloadMe.globalUnitList.erase(myUnit)
			if myUnit.Faction == myUnit.fac.ALLY:
				AutoloadMe.globalAllyList.erase(myUnit)
			else:
				AutoloadMe.deathCount += 1
				AutoloadMe.globalEnemyList.erase(myUnit)
			
			#get_parent().get_parent().get_parent().nodeList = [] # 
			SignalBus.updateInitBox.emit()
			SignalBus.updateGrid.emit()
			myUnit.queue_free()
			queue_free()
