extends Node2D

var unitList = []
var grid

func _ready():
	Engine.max_fps = 60
	AutoloadMe.new_level()
	#get_node("Grid/InitManager/UnitManager/Lumoth").add_passive("TestPassive")
	
	#get_node("Grid/InitManager").next_turn()
	SignalBus.silenceMusic.emit()
	AutoloadMe.set_process_unhandled_input(true)
	Dialogic.start("res://Dialogic Assets/Timelines/Garden Intro.dtl")
	
	#SignalBus.showInfoBox.emit()

func process():
	pass
