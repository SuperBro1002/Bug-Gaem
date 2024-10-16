extends Node

var current_timeline
var node

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("startTurn", set_timeline)
	
func set_timeline():
	if Dialogic.VAR.CutsceneUp == true: return
	var cur_unit = AutoloadMe.turnPointer
	
	if cur_unit.Faction == cur_unit.fac.ALLY:
		Dialogic.VAR.DialogueComplete = false
		match AutoloadMe.mapID:
			1: current_timeline = "res://Dialogic Assets/Timelines/FountainBattle.dtl"
			2: current_timeline = "res://Dialogic Assets/Timelines/Cathedral1Battle.dtl"
			3: current_timeline = "res://Dialogic Assets/Timelines/GardenBattle.dtl"
			4: current_timeline = "res://Dialogic Assets/Timelines/Cathedral2Battle.dtl"
			5: current_timeline = "res://Dialogic Assets/Timelines/Fountain2Battle.dtl"
			_: print("fuck")
			
		# TO DO: CHECK WHAT SCENE WE'RE IN. USE THAT AS LABEL
		node = Dialogic.start(current_timeline)
		var layout := Dialogic.Styles.get_layout_node()
		node.set_visible(false)
		node.register_character(load("res://Dialogic Assets/Characters/Atlas.dch"), get_child(0))
		node.register_character(load("res://Dialogic Assets/Characters/Lumoth.dch"), get_child(0))
		node.register_character(load("res://Dialogic Assets/Characters/Triss.dch"), get_child(0))
		node.register_character(load("res://Dialogic Assets/Characters/Paramantis.dch"), get_child(0))
		node.register_character(load("res://Dialogic Assets/Characters/Atlas2.dch"), get_child(1))
		node.register_character(load("res://Dialogic Assets/Characters/Lumoth2.dch"), get_child(1))
		node.register_character(load("res://Dialogic Assets/Characters/Triss2.dch"), get_child(1))
		node.register_character(load("res://Dialogic Assets/Characters/Paramantis2.dch"), get_child(1))
		node.register_character(load("res://Dialogic Assets/Characters/Drone.dch"), get_child(1))
		node.register_character(load("res://Dialogic Assets/Characters/Auri.dch"), get_child(1))
		node.register_character(load("res://Dialogic Assets/Characters/Thoraxe.dch"), get_child(1))
		node.set_visible(true)
