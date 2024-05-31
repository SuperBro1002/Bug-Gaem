extends Node2D

var unitList = []
var grid

func _ready():
	Engine.max_fps = 60
	get_node("Grid/InitManager/UnitManager/Atlus").add_passive("Armor")
	#get_node("Grid/InitManager/UnitManager/Atlus").add_passive("Poison")
	get_node("Grid/InitManager/UnitManager/Atlus").add_passive("Bless")
	get_node("Grid/InitManager/UnitManager/Atlus").add_passive("Empowered_Attack")
	get_node("Grid/InitManager").next_turn()

func process():
	pass
