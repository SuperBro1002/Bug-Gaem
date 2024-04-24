extends Node

var current_timeline

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("startTurn", set_timeline)
	
func set_timeline():
	var cur_unit = AutoloadMe.turnPointer
	if cur_unit.Faction == cur_unit.fac.ALLY:
			for p in cur_unit.passiveList.size():
				if cur_unit.passiveList[p].is_narrative:
					var passive = cur_unit.passiveList[p]
					current_timeline = "res://Dialogic Assets/Timelines/" + passive.timeline + ".dtl"
					var node := Dialogic.start(current_timeline, passive.label)
					node.register_character(load("res://Dialogic Assets/Characters/Atlas.dch"), get_child(0))
					node.register_character(load("res://Dialogic Assets/Characters/Lumoth.dch"), get_child(0))
					node.register_character(load("res://Dialogic Assets/Characters/Triss.dch"), get_child(0))
					node.register_character(load("res://Dialogic Assets/Characters/Paramantis.dch"), get_child(0))
	print("No timeline to use")
