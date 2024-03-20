extends Control

var boxArray = []
var nodeList = []

func _ready():
	SignalBus.connect("currentUnit", set_ui)
	SignalBus.connect("updateUI", set_ui)
	SignalBus.connect("updateInitBox", draw_init_box)
	SignalBus.connect("actedUI", set_init_colors)
	draw_init_box()

func set_ui(unit):
	if unit.get_faction() == unit.fac.ALLY:
		var portraitRes = load("res://Assets/Sprites/Allies/" + unit.Name + "/" + unit.Name + "_Base_Still.png")
		get_node("../UI/InfoBox/PortraitBox/PortraitSprite").texture = portraitRes
		
		var nameVal = unit.Name
		$InfoBox/Name.set_text(nameVal)
		
		var hpVal = str(unit.get_current_hp()) + " / " + str(unit.get_max_hp())
		$InfoBox/HPValue.set_text(hpVal)
		
		var apVal = str(unit.get_temp_ap()) + " / " + str(unit.get_max_ap())
		$InfoBox/APValue.set_text(apVal)
		
	for i in boxArray.size():
		boxArray[i].update_display()

func toggle_UI():
	pass

func draw_init_box():
	boxArray = []
	var sceneNode
	
	if nodeList != []:
		clear_init_box()
	
	for i in AutoloadMe.globalUnitList.size() - 1:
		var scene = load("res://Scenes/Unit_Initiative_Box.tscn")
		sceneNode = scene.instantiate()
#		get_node("../CenterContainer/Sprite2D").texture = load("res://Assets/HUD/Init_Sprites/" + AutoloadMe.globalUnitList[i].fileName + "_Base_Still.png")
		sceneNode.assign_unit(AutoloadMe.globalUnitList[i])
		boxArray.append(sceneNode)
		if i == 0:
			get_node("../UI/ColorRect/HBoxContainer").add_child(sceneNode)
		else:
			boxArray[i - 1].add_sibling(sceneNode)
	nodeList = get_node("../UI/ColorRect/HBoxContainer").get_children()

func set_init_colors():
	for i in nodeList.size():
		nodeList[i].set_colors()

func clear_init_box():
	nodeList = get_node("../UI/ColorRect/HBoxContainer").get_children()
	for i in nodeList:
		get_node("../UI/ColorRect/HBoxContainer").remove_child(i)
		SignalBus.deleteInitObject.emit()
