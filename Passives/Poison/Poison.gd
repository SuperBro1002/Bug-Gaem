extends Passive_class

func _enter_tree():
	Name = "Poison"
	turnsRemaining = 3
	description = str("This fighter is infected with a parasitic poison, dealing 1 damage per turn for ", turnsRemaining, "more turns.")
	SignalBus.connect("deletePassives", passive_remove)
	type = methodType.ON_TURN_START

func execute(num):
	get_parent().incoming_dmg_type = "pierce"
	get_parent().passive_lose_health(1)
	turnsRemaining -= 1
	#print("Turns remaining: ", turnsRemaining)
