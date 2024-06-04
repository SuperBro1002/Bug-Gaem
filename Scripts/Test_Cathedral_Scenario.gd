extends Node2D

var unitList = []
var grid

func _ready():
	Engine.max_fps = 60
	AutoloadMe.new_level()
	#get_node("Grid/InitManager/UnitManager/Lumoth").add_passive("TestPassive")
	#get_node("Grid/InitManager").next_turn()
	Dialogic.start("res://Dialogic Assets/Timelines/Cathedral 1 Intro.dtl")

func process():
	pass
