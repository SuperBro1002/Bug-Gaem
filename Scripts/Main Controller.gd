extends Node2D

var unitList = []
var grid

func _ready():
	Engine.max_fps = 60
	get_node("Grid/InitManager/UnitManager/Lumoth").add_passive("TestPassive")
	get_node("Grid/InitManager").next_turn()

func process():
	pass
