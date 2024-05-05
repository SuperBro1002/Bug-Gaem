extends Ability_class

var healNum = 2

func _enter_tree():
	targetType = [get_parent().fac.ALLY]
	Name = "Heal"
	description = "Heals an adjacent ally for 3 health. 6 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED ", AutoloadMe.currentAbility)
	print(targetUnits)
	
	for i in targetUnits.size():
		targetUnits[i].gain_health(healNum)
	
	healNum = 3
	
	post_execute()
