extends Control

var animationSpeed = 4
var boxArray = []
var nodeList
var ability1
var ability2
var ability3

func _ready():
	get_parent().set_visible(true)
	SignalBus.connect("currentUnit", set_ui)
	SignalBus.connect("currentUnit", start_anim)
	SignalBus.connect("updateUI", set_ui)
	SignalBus.connect("updateInitBox", draw_init_box)
	SignalBus.connect("addInitBox", add_init_box)
	SignalBus.connect("actedUI", set_init_colors)
	SignalBus.connect("mouseHovering", toggle_secondary)
	SignalBus.connect("startTurn", show_infoBox)
	SignalBus.connect("abilityExecuted", clear_tile_paths)
	SignalBus.connect("wipeTilePaths", clear_tile_paths)
	SignalBus.connect("moveCamera", hide_ui)
	SignalBus.connect("showUI", show_ui)
	SignalBus.connect("changeControls", set_control_text)
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
		
		
		ability1 = unit.ability1
		$InfoBox/AbilityBox/Ability1Button.set_text(ability1.Name)
		
		if !unit.isPossessed:
			ability2 = unit.ability2
			$InfoBox/AbilityBox/Ability2Button.set_text(ability2.Name)
			$InfoBox/AbilityBox/Ability2Button.set_visible(true)
		else:
			$InfoBox/AbilityBox/Ability2Button.set_visible(false)
		
		if !unit.isPossessed:
			ability3 = unit.ability3
			$InfoBox/AbilityBox/Ability3Button.set_text(ability3.Name)
			$InfoBox/AbilityBox/Ability3Button.set_visible(true)
		else:
			$InfoBox/AbilityBox/Ability3Button.set_visible(false)
		
	display_movement_range()
	draw_tile_path()
	boxArray = get_node("../UI/ColorRect/ScrollContainer/HBoxContainer").get_children()
	for i in boxArray.size():
		#print("HERE ", boxArray)
	#	ifboxArray[i] == null:
			
		boxArray[i].update_display()

func toggle_UI():
	pass

func draw_init_box():
	boxArray = []
	var sceneNode
	nodeList = get_node("../UI/ColorRect/ScrollContainer/HBoxContainer").get_children()
	
	if nodeList != []:
		clear_init_box()
	
	for i in AutoloadMe.globalUnitList.size() - 1:
		var scene = load("res://Scenes/Unit_Initiative_Box.tscn")
		sceneNode = scene.instantiate()
		sceneNode.assign_unit(AutoloadMe.globalUnitList[i])
		boxArray.append(sceneNode)
		if i == 0:
			get_node("../UI/ColorRect/ScrollContainer/HBoxContainer").add_child(sceneNode)
			sceneNode.UINode = self
		else:
			boxArray[i - 1].add_sibling(sceneNode)
			sceneNode.UINode = self

func set_init_colors():
	nodeList = get_node("../UI/ColorRect/ScrollContainer/HBoxContainer").get_children()
	for i in nodeList.size():
		nodeList[i].set_colors()

func add_init_box(target):
	var sceneNode
	var scene = load("res://Scenes/Unit_Initiative_Box.tscn")
	sceneNode = scene.instantiate()
	sceneNode.assign_unit(target)
	get_node("../UI/ColorRect/ScrollContainer/HBoxContainer").add_child(sceneNode)
	sceneNode.UINode = self

func remove_init_box(target):
	print("BEFORE: ", nodeList)
	nodeList = get_node("../UI/ColorRect/ScrollContainer/HBoxContainer").get_children()
	nodeList.pop_at(nodeList.find(target))
	get_node("../UI/ColorRect/ScrollContainer/HBoxContainer").remove_child(target)
	
	print("AFTER: ", get_node("../UI/ColorRect/ScrollContainer/HBoxContainer").get_children())

func clear_init_box():
	nodeList = get_node("../UI/ColorRect/ScrollContainer/HBoxContainer").get_children()
	for i in nodeList:
		get_node("../UI/ColorRect/ScrollContainer/HBoxContainer").remove_child(i)
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

func draw_tile_path():
	clear_tile_paths(null)
	if AutoloadMe.turnPointer.get_faction() != AutoloadMe.turnPointer.fac.ALLY or AutoloadMe.turnPointer.start == AutoloadMe.turnPointer.end:
		return
	var tiles = AutoloadMe.turnPointer.pathArray
	if tiles == null:
		return
	for i in tiles.size():
		var tileOverlay = Sprite2D.new()
		tileOverlay.texture = load("res://Assets/HUD/PathTile.png")
		$"../../Grid/PathTiles".add_child(tileOverlay)
		tileOverlay.position = tiles[i]

func clear_tile_paths(_unit):
	var tiles = $"../../Grid/PathTiles".get_children()
	if tiles != null:
		print("running")
		for i in tiles.size():
			tiles[i].queue_free()

func display_movement_range():
	clear_tile_Overlays()
	if AutoloadMe.turnPointer.get_faction() != AutoloadMe.turnPointer.fac.ALLY:
		return
	var tiles = AutoloadMe.turnPointer.get_reachable_tiles()
	for i in tiles.size():
		var tileOverlay = Sprite2D.new()
		tileOverlay.texture = load("res://Assets/HUD/ValidTile.png")
		$"../../Grid/ValidTiles".add_child(tileOverlay)
		tileOverlay.position = tiles[i]

func clear_tile_Overlays():
	var tiles = $"../../Grid/ValidTiles".get_children()
	if tiles != null:
		for i in tiles:
			i.queue_free()

func set_control_text():
	if AutoloadMe.queueState:
		$ControlsOverlay/ContextButtons1.set_text("Left Click - Select Target")
		$ControlsOverlay/AbilityQueueControls.set_text("1,2,3 - Deselect/Change Ability")
		if AutoloadMe.validQueue:
			$ControlsOverlay/ContextButtons2.set_text("Z - Confirm Ability")
		else:
			$ControlsOverlay/ContextButtons2.set_text("")
	else:
		$ControlsOverlay/ContextButtons1.set_text("WASD - Move")
		$ControlsOverlay/AbilityQueueControls.set_text("1,2,3 - Select Ability")
		if AutoloadMe.allowEndTurn and AutoloadMe.notOverlapped:
			$ControlsOverlay/ContextButtons2.set_text("X - End Turn")
		else:
			$ControlsOverlay/ContextButtons2.set_text("")
			$ControlsOverlay/AbilityQueueControls.set_text("")

func hide_ui():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)

func show_ui():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)

func start_anim(unit):
	if unit.get_faction() != unit.fac.ALLY and unit.get_faction() != unit.fac.ENEMY:
		return
	$ControlsOverlay.set_visible(false)
	show_ui()
	if unit.get_batonpass() == unit.TS.NOTACTED:
		$TurnGraphic.set_text(unit.Name + "\nStart")
		$TurnGraphic.label_settings.shadow_color = Color(0, 0, 0, 1)
	elif unit.get_batonpass() == unit.TS.BATONPASS:
		$TurnGraphic.set_text(unit.Name + "\nBaton Pass")
		if unit.get_faction() == unit.fac.ALLY:
			$TurnGraphic.label_settings.shadow_color = Color(0, 1, 1, 1)
		else:
			$TurnGraphic.label_settings.shadow_color = Color(1, 0.5, 0, 1)
	
	if unit.get_faction() == unit.fac.ENEMY:
		$TurnGraphic.label_settings.font_color = Color(1, 0.1, 0.2, 1)
	elif unit.get_faction() == unit.fac.ALLY:
		$TurnGraphic.label_settings.font_color = Color(0, 0.518, 0.969, 1)
		
	var tween = create_tween()
	tween.tween_property($TurnGraphic, "position:x", -1300, 3.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT_IN)
	await tween.finished
	$TurnGraphic.position.x = 1934
	AutoloadMe.set_process_unhandled_input(true)
	$ControlsOverlay.set_visible(true)



func _on_ability_1_button_mouse_entered():
	var tween = create_tween()
	$AbilityDescBox.set_my_text(ability1)
	tween.tween_property(get_node("../UI/AbilityDescBox"), "modulate:a", 1, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)

func _on_ability_1_button_mouse_exited():
	var tween = create_tween()
	tween.tween_property(get_node("../UI/AbilityDescBox"), "modulate:a", 0, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)


func _on_ability_2_button_mouse_entered():
	var tween = create_tween()
	$AbilityDescBox.set_my_text(ability2)
	tween.tween_property(get_node("../UI/AbilityDescBox"), "modulate:a", 1, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)

func _on_ability_2_button_mouse_exited():
	var tween = create_tween()
	tween.tween_property(get_node("../UI/AbilityDescBox"), "modulate:a", 0, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)


func _on_ability_3_button_mouse_entered():
	var tween = create_tween()
	$AbilityDescBox.set_my_text(ability3)
	tween.tween_property(get_node("../UI/AbilityDescBox"), "modulate:a", 1, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)

func _on_ability_3_button_mouse_exited():
	var tween = create_tween()
	tween.tween_property(get_node("../UI/AbilityDescBox"), "modulate:a", 0, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)
