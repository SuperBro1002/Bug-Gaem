extends Passive_class

func _enter_tree():
	turnsRemaining = 3
	SignalBus.connect("deletePassives", passive_remove)
	type = methodType.ON_TURN_START

func execute(num):
	get_parent().incoming_dmg_type = "pierce"
	get_parent().lose_health(1)
	print("POISON DAMAGE TAKEN")
	turnsRemaining -= 1
