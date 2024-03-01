extends Passive_class

turnsRemaining = 3

func _enter_tree():
	type = methodType.ON_TURN_START

func execute(num):
	get_parent().incoming_dmg_type = "pierce"
	get_parent().lose_health(5)
	turnsRemaining -= 1
	
	if turnsRemaining <= 0:
		queue_free()
