extends Node2D

var unitList = []
var grid

func _ready():
	Engine.max_fps = 60
	AutoloadMe.new_level()
	#get_node("Grid/InitManager/UnitManager/Lumoth").add_passive("TestPassive")
	#get_node("Grid/InitManager").next_turn()
	if AutoloadMe.mapID == 2:
		#SignalBus.playMusic.emit("Lunar Eclipse")
		SignalBus.silenceMusic.emit()
		AutoloadMe.set_process_unhandled_input(true)
		Dialogic.start("res://Dialogic Assets/Timelines/Cathedral 1 Intro.dtl")
	if AutoloadMe.mapID == 4: 
		#SignalBus.playMusic.emit("Metamorphosis")
		SignalBus.silenceMusic.emit()
		AutoloadMe.set_process_unhandled_input(true)
		Dialogic.start("res://Dialogic Assets/Timelines/Cathedral 2 Intro.dtl")
func process():
	pass
