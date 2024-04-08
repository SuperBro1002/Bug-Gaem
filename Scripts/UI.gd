extends Control

var animationSpeed = 4
var boxArray = []
var nodeList

func _ready():
	SignalBus.connect("currentUnit", set_ui)
	SignalBus.connect("updateUI", set_ui)
	SignalBus.connect("updateInitBox", draw_init_box)
	SignalBus.connect("actedUI", set_init_colors)
	SignalBus.connect("mouseHovering", toggle_secondary)
	SignalBus.connect("startTurn", show_infoBox)
	draw_init_box()

func set_ui(unit):
	if unit.get_faction() == unit.fac.ALLY:
		var portraitRes = load("res://Assets/Sprites/" + unit.fileName + "/" + unit.fileName + "_Base_Still.png")
		get_node("../UI/InfoBox/PortraitBox/PortraitSprite").texture = portraitRes
		
		var nameVal = unit.Name
		$InfoBox/Name.set_text(nameVal)
		
		var hpVal = str(unit.get_current_hp()) + " / " + str(unit.get_max_hp())
		$InfoBox/HPValue.set_text(hpVal)
		
		var apVal = str(unit.get_temp_ap()) + " / " + str(unit.get_max_ap())
		$InfoBox/APValue.set_text(apVal)
		SignalBus.updateFloatingAP.emit(unit.get_temp_ap())
	
	for i in boxArray.size():
		boxArray[i].update_display()

func toggle_UI():
	pass

func draw_init_box():
	boxArray = []
	var sceneNode
	nodeList = get_node("../UI/ColorRect/HBoxContainer").get_children()
	
	if nodeList != []:
		clear_init_box()
	
	for i in AutoloadMe.globalUnitList.size() - 1:
		var scene = load("res://Scenes/Unit_Initiative_Box.tscn")
		sceneNode = scene.instantiate()
		sceneNode.assign_unit(AutoloadMe.globalUnitList[i])
		boxArray.append(sceneNode)
		if i == 0:
			get_node("../UI/ColorRect/HBoxContainer").add_child(sceneNode)
		else:
			boxArray[i - 1].add_sibling(sceneNode)

func set_init_colors():
	nodeList = get_node("../UI/ColorRect/HBoxContainer").get_children()
	for i in nodeList.size():
		nodeList[i].set_colors()

func clear_init_box():
	nodeList = get_node("../UI/ColorRect/HBoxContainer").get_children()
	for i in nodeList:
		get_node("../UI/ColorRect/HBoxContainer").remove_child(i)
		SignalBus.deleteInitObject.emit()

func toggle_secondary(isHovering):
	var tween = create_tween()
	if isHovering:
		tween.tween_property(get_node("../UI/SecondaryInfoBox"), "modulate:a", 1, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)
	else:
		tween.tween_property(get_node("../UI/SecondaryInfoBox"), "modulate:a", 0, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)

func show_infoBox():
	if AutoloadMe.turnPointer.get_faction() == AutoloadMe.turnPointer.fac.ALLY and $InfoBox.is_visible() == false:
		$InfoBox.set_visible(true)
	elif AutoloadMe.turnPointer.get_faction() == AutoloadMe.turnPointer.fac.ENEMY and $InfoBox.is_visible() == true:
		$InfoBox.set_visible(false)
