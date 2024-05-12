extends Passive_class

func _enter_tree():
	SignalBus.connect("deletePassives", passive_remove)
	type = methodType.ABILITY_EXECUTE

func execute(num):
	if AutoloadMe.currentAbility.myType == AutoloadMe.currentAbility.abilityType.DAMAGING:
		print("DAMAGE BOOSTED")
		AutoloadMe.currentAbility.dmgMod = 2
		turnsRemaining = 0
		get_parent().find_and_delete_passives()
