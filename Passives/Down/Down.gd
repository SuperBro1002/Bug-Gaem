extends Passive_class

func _enter_tree():
	turnsRemaining = 3
	SignalBus.connect("deletePassives", passive_remove)
	Name = "Down"
	description = str("The Great Tree will revive them in ", turnsRemaining, "turns.")
	# TO DO: POSSIBLY SWAP OUT SPRITE
	get_parent().isDown = true
	type = methodType.ON_TURN_START

func execute(_num):
	turnsRemaining -= 1
	get_parent().gain_health(get_parent().get_max_hp()/3)
	get_parent().lose_ap(1000)

func passive_remove():
	get_parent().isDown = false
	if turnsRemaining <= 0:
		queue_free()
