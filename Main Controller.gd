extends Node2D

enum level {
	LEVEL1,
	LEVEL2,
	LEVEL3
}

var unitList = []
var test

func _ready():
	pass

func process():
	pass

# Creates a list of all the units in a level
func make_unit_list():
	unitList.append($Grid/Ally)
	unitList.append($Grid/Enemy)

