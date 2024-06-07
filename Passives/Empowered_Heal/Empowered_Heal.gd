extends Passive_class

func _enter_tree():
	Name = "Empowered Heal"
	description = "Healing is increased by 1."
	SignalBus.connect("deletePassives", passive_remove)
	type = methodType.ABILITY_EXECUTE

func execute(num):
	if AutoloadMe.currentAbility.fileName == "Heal":
		print("RECOVERY BOOSTED")
		AutoloadMe.currentAbility.healNum += 1
		turnsRemaining = 0
		get_parent().find_and_delete_passives()
