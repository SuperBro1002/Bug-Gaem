@tool
extends Node
class_name Passive_class

enum methodType {
	GAIN_HEALTH,
	LOSE_HEALTH,
	GAIN_AP,
	LOSE_AP,
	ON_TURN_START,
	ON_TURN_END,
	IMMEDIATE_PERSISTING,
	ABILITY_EXECUTE
}

var turnsRemaining = 1000
var type
var is_narrative = false
var timeline = null
var label = null

func get_type():
	return type

func passive_remove():
	if turnsRemaining <= 0:
		queue_free()
