extends Passive_class

func _enter_tree():
	turnsRemaining = 1
	SignalBus.connect("deletePassives", passive_remove)
	type = methodType.ON_TURN_END

func execute(num):
	get_parent().incoming_dmg_type = "pierce"
	get_parent().lose_health(get_parent().get_current_hp())