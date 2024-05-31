extends Passive_class

func _enter_tree():
	Name = "Trap"
	turnsRemaining = 1
	description = "This fighter cannot move for " + turnsRemaining + " more turns."
	SignalBus.connect("deletePassives", passive_remove)
	type = methodType.ON_TURN_START

func execute(num):
	get_parent().canMove = false
	turnsRemaining -= 1

func passive_remove():
	if turnsRemaining <= 0:
		queue_free()
