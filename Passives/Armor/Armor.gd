extends Node

var type = "LOSE_HEALTH"

func get_type():
	return type

func execute(num):
	num = num - 1
	if num < 0:
		num = 0
	return num
