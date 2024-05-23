extends Control

var myUnit
var glowTween
var colorTween
var UINode

func _ready():
	SignalBus.connect("deleteInitObject", remove_me)
	SignalBus.connect("deleteMe", delete_box)
	SignalBus.connect("highlightInit", glow)
	#SignalBus.connect("endTurn", kill_glow)
	SignalBus.connect("endRound", reset_colors)

func assign_unit(unit):
	myUnit = unit
	myUnit.myInitBox = self
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
	if glowTween:
		glowTween.kill()
	if myUnit.get_batonpass() == myUnit.TS.ACTED and myUnit == AutoloadMe.turnPointer:
		colorTween = create_tween()
		colorTween.tween_property(self, "modulate", Color(0.42, 0.42, 0.42), 0.2).set_trans(Tween.TRANS_SINE)

func reset_colors():
	if !is_inside_tree():
		return
	await get_tree().create_timer(0.2).timeout
	if colorTween:
		colorTween.kill()
	colorTween = create_tween()
	colorTween.tween_property(self, "modulate", Color(1, 1, 1), 0.2).set_trans(Tween.TRANS_SINE)

func glow(unit, switch):
	if get_parent() == null:
		return
	if myUnit != unit:
		if glowTween:
			glowTween.kill()
			glowTween = create_tween().bind_node(self)
			glowTween.tween_property($CurrentUnit, "color:a", 0, 0.5).set_trans(Tween.TRANS_SINE)
		return
	if switch:
		if glowTween:
			glowTween.kill()
		glowTween = create_tween().set_loops().bind_node(self)
		glowTween.tween_property($CurrentUnit, "color:a", 0.6, 0.5).set_trans(Tween.TRANS_SINE)
		glowTween.tween_property($CurrentUnit, "color:a", 0, 0.5).set_trans(Tween.TRANS_SINE)
	elif glowTween:
		glowTween.kill()
		glowTween = create_tween().bind_node(self)
		glowTween.tween_property($CurrentUnit, "color:a", 0, 0.5).set_trans(Tween.TRANS_SINE)

func remove_me():
	queue_free()

func delete_box(toBeDeleted):
	# Removes unit from UnitLists so it won't be added to InitBox
	if toBeDeleted == myUnit:
		UINode.remove_init_box(self)
		SignalBus.updateUI.emit(AutoloadMe.turnPointer)
		#myUnit.queue_free()
		myUnit.myInitBox = null
		if AutoloadMe.turnPointer == toBeDeleted:
			SignalBus.endTurn.emit()
		
		queue_free()


func _on_mouse_entered():
	print("Hovering")
	AutoloadMe.hoveredUnit = myUnit
	SignalBus.mouseHovering.emit(true)
	SignalBus.highlightUnit.emit(myUnit, true)

func _on_mouse_exited():
	SignalBus.mouseHovering.emit(false)
	SignalBus.highlightUnit.emit(myUnit, false)
