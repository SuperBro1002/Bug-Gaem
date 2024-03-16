extends Passive_class

func _enter_tree():
	turnsRemaining = 1
	SignalBus.connect("deletePassives", passive_remove)
	type = methodType.ON_TURN_START

func execute(num):
	get_parent().canMove = false
	turnsRemaining -= 1
	#print("Turns remaining: ", turnsRemaining)

func passive_remove():
	if turnsRemaining <= 0:
		queue_free()
