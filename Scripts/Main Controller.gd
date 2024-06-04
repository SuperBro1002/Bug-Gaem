extends Node2D

var unitList = []
var grid

func _ready():
	Engine.max_fps = 60
	AutoloadMe.new_level()
	#get_node("Grid/InitManager/UnitManager/Lumoth").add_passive("TestPassive")
	if AutoloadMe.mapID == 1: Dialogic.start("res://Dialogic Assets/Timelines/Fountain Intro.dtl")
	if AutoloadMe.mapID == 5: pass
	
func process():
	pass
