extends Node2D

var unitList = []
var grid

func _ready():
	Engine.max_fps = 60
	AutoloadMe.new_level()
	##get_node("Grid/InitManager").next_turn()
	#get_node("Grid/InitManager/UnitManager/Lumoth").add_passive("TestPassive")
	if AutoloadMe.mapID == 1: 
		##get_node("Grid/InitManager").next_turn()
		Dialogic.start("res://Dialogic Assets/Timelines/Fountain Intro.dtl")
		SignalBus.playMusic.emit("Bioluminescence")
	if AutoloadMe.mapID == 5: 
		AutoloadMe.set_process_unhandled_input(true)
		Dialogic.start("res://Dialogic Assets/Timelines/Fountain 2 Intro.dtl")
		SignalBus.silenceMusic.emit()
	
func process():
	pass
