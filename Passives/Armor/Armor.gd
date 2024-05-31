extends Passive_class

func _enter_tree():
	Name = "Armor"
	description = "Reduces incoming damage by 1. Piercing and poison-based damage avoid this effect."
	type = methodType.LOSE_HEALTH

func execute(num):
	if get_parent().incoming_dmg_type != "pierce":
		num = 0
		#if num < 0:
			#num = 0
		turnsRemaining = 0
		return num
	else: return num
