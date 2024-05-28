extends Node2D

var unitList = []
var grid

func _ready():
	Engine.max_fps = 60
	get_node("Grid/InitManager/UnitManager/Lumoth").add_passive("Cleric")
	get_node("Grid/InitManager/UnitManager/Atlus").add_passive("Veteran")
	get_node("Grid/InitManager/UnitManager/Paramantis").add_passive("Shaman")
	get_node("Grid/InitManager/UnitManager/Triss").add_passive("Nobeelity")
	get_node("Grid/InitManager").next_turn()

func process():
	pass
