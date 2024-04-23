extends Passive_class

var stage = 1

func _enter_tree():
	type = methodType.ON_TURN_START
	is_narrative = true
	timeline = "testline"
	label = "First"

func execute(num):
	stage = stage + 1
	return
