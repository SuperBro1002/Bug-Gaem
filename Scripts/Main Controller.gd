extends Node2D

var unitList = []
var grid

func _ready():
	get_node("Grid/InitManager").next_turn()

func process():
	pass
