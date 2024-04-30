extends Control

var myUnit
var tween
var colorTween

func _ready():
	SignalBus.connect("deleteInitObject", remove_me)
	SignalBus.connect("deleteMe", death)
	SignalBus.connect("startTurn", glow)
	SignalBus.connect("endTurn", kill_glow)
	SignalBus.connect("endRound", reset_colors)

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
	if myUnit.get_batonpass() == myUnit.TS.ACTED and myUnit == AutoloadMe.turnPointer:
		colorTween = create_tween()
		colorTween.tween_property(self, "modulate", Color(0.42, 0.42, 0.42), 0.2).set_trans(Tween.TRANS_SINE)

func reset_colors():
	if get_tree() == null:
		return
	await get_tree().create_timer(0.2).timeout
	if colorTween:
		colorTween.kill()
	colorTween = create_tween()
	colorTween.tween_property(self, "modulate", Color(1, 1, 1), 0.2).set_trans(Tween.TRANS_SINE)

func glow():
	if get_parent() == null:
		return
	if tween:
		tween.kill()
	while AutoloadMe.turnPointer == myUnit:
			tween = create_tween()
			
			tween.tween_property($CurrentUnit, "color:a", 0.4, 1.0).set_trans(Tween.TRANS_SINE)
			await tween.finished
			
			tween = create_tween()
			
			tween.tween_property($CurrentUnit, "color:a", 0, 1.0).set_trans(Tween.TRANS_SINE)
			await tween.finished


func kill_glow():
	$CurrentUnit.set_color(Color(1,1,1,0))

func remove_me():
	queue_free()

func death(toBeDeleted):
	# Removes unit from UnitLists so it won't be added to InitBox
	if toBeDeleted == myUnit:
		print("I AM DYING")
		AutoloadMe.globalUnitList.erase(myUnit)
		AutoloadMe.globalEnemyList.erase(myUnit)
		AutoloadMe.globalAllyList.erase(myUnit)
		if myUnit.Faction == myUnit.fac.ENEMY:
			AutoloadMe.deathCount += 1
		
		SignalBus.updateInitBox.emit()
		SignalBus.updateGrid.emit()
		SignalBus.updateUI.emit(AutoloadMe.turnPointer)
		myUnit.queue_free()
		
		if AutoloadMe.turnPointer == toBeDeleted:
			SignalBus.endTurn.emit()
		
		queue_free()
