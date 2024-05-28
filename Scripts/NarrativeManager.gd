extends Node

var current_timeline
var node
var passive

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("startTurn", set_timeline)
	
func set_timeline():
	var cur_unit = AutoloadMe.turnPointer
	if cur_unit.Faction == cur_unit.fac.ALLY:
			for p in cur_unit.passiveList.size():
				if cur_unit.passiveList[p].is_narrative:
					passive = cur_unit.passiveList[p]
					current_timeline = "res://Dialogic Assets/Timelines/" + passive.timeline + ".dtl"
					node = Dialogic.start(current_timeline, "First")
					node.register_character(load("res://Dialogic Assets/Characters/Atlas.dch"), get_child(0))
					node.register_character(load("res://Dialogic Assets/Characters/Lumoth.dch"), get_child(0))
					node.register_character(load("res://Dialogic Assets/Characters/Triss.dch"), get_child(0))
					node.register_character(load("res://Dialogic Assets/Characters/Paramantis.dch"), get_child(0))
					node.register_character(load("res://Dialogic Assets/Characters/Atlas2.dch"), get_child(1))
					node.register_character(load("res://Dialogic Assets/Characters/Lumoth2.dch"), get_child(1))
					node.register_character(load("res://Dialogic Assets/Characters/Triss2.dch"), get_child(1))
					node.register_character(load("res://Dialogic Assets/Characters/Paramantis2.dch"), get_child(1))
					node.register_character(load("res://Dialogic Assets/Characters/Drone.dch"), get_child(1))
					node.register_character(load("res://Dialogic Assets/Characters/Thoraxe.dch"), get_child(1))
