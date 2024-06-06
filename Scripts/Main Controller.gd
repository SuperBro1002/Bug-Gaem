extends Node2D

var unitList = []
var grid

func _ready():
	Engine.max_fps = 60
	AutoloadMe.new_level()
	#get_node("Grid/InitManager/UnitManager/Lumoth").add_passive("TestPassive")
	if AutoloadMe.mapID == 1: 
		Dialogic.start("res://Dialogic Assets/Timelines/Fountain Intro.dtl")
		SignalBus.playMusic.emit("Bioluminescence")
	if AutoloadMe.mapID == 5: 
		Dialogic.start("res://Dialogic Assets/Timelines/Fountain 2 Intro.dtl")
		SignalBus.silenceMusic.emit()
	
func process():
	pass
