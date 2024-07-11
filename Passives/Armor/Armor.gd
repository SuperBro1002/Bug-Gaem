extends Passive_class

func _enter_tree():
	SignalBus.connect("deletePassives", passive_remove)
	Name = "Armor"
	description = "Damage from next attack is nullified. Damage from poison is unaffected."
	type = methodType.LOSE_HEALTH

func execute(num):
	if get_parent().incoming_dmg_type != "pierce":
		num = 0
		turnsRemaining = 0
		get_parent().find_and_delete_passives()
		
	return num
