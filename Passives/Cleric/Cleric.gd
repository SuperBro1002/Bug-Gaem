extends Passive_class

func _enter_tree():
	type = methodType.ON_TURN_START
	is_narrative = true
	timeline = "Cleric"
	
func execute(num):
	return
