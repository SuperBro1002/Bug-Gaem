extends Passive_class

func _enter_tree():
	Name = "Bless"
	description = "Doubles healing received."
	type = methodType.GAIN_HEALTH

func execute(num):
	return num * 2
