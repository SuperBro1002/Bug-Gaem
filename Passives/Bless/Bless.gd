extends Passive_class

func _enter_tree():
	type = methodType.GAIN_HEALTH

func execute(num):
	return num * 2
