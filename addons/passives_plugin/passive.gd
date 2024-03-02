@tool
extends Node
class_name Passive_class

enum methodType {
	GAIN_HEALTH,
	LOSE_HEALTH,
	GAIN_AP,
	LOSE_AP,
	ON_TURN_START
}

var turnsRemaining = 1000
var type

func get_type():
	return type

func passive_remove():
	if turnsRemaining <= 0:
		queue_free()
