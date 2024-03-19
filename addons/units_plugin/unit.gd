@tool
extends Area2D
class_name Unit_class

enum fac {
	ALLY,
	ENEMY,
	NONE
}

enum TS {
	BATONPASS,
	ACTED,
	NOTACTED
}

enum methodType {
	GAIN_HEALTH,
	LOSE_HEALTH,
	GAIN_AP,
	LOSE_AP,
	ON_TURN_START,
	ON_TURN_END
}

var passiveList = []
var incoming_dmg_type = null # pierce, null

@export var Name = "Default"
@export var fileName = "Default"
@export var ID = 0
@export var MaxHP = 20
@export var CurrentHP = 20
@export var MaxAP = 5
@export var CurrentAP = 5
@export var TrueInit = 7
@export var CurrentInit = 3
@export var SetAbility1 = "Stab"
@export var SetAbility2 = "Stab"
@export var SetAbility3 = "Stab"
@export var Faction = fac.NONE
@export var BatonPass = TS.NOTACTED

@onready var tempAP = get_max_ap()
@onready var grid = get_parent().get_parent().get_parent()
@onready var start = grid.convert_to_map(position)
@onready var abilityStartPoint = grid.convert_to_map(position)
@onready var end = grid.convert_to_map(position)

var canMove = true
var storedBatonPass = TS.NOTACTED

func _enter_tree():
	SignalBus.connect("abilityExecuted",on_execute)

func init_stats(max_hp, current_hp, max_ap, current_ap, True_init, current_init, faction, bp):
	# Assign the given values to their respective stats
	MaxHP = max_hp
	CurrentHP = current_hp
	MaxAP = max_ap
	CurrentAP = current_ap
	TrueInit = True_init
	CurrentInit = current_init
	Faction = faction
	BatonPass = bp

func get_id():
	# Returns the id of this unit
	return ID


func get_current_hp():
	# Returns unit's current hp
	return CurrentHP

func gain_health(recoverVal):
	# Adds given num to unit's current hp
	recoverVal = run_passives(methodType.GAIN_HEALTH, recoverVal)
	CurrentHP = CurrentHP + recoverVal
	if CurrentHP > MaxHP:
		CurrentHP = MaxHP

func lose_health(dmgVal):
	dmgVal = run_passives(methodType.LOSE_HEALTH, dmgVal)
	CurrentHP = CurrentHP - dmgVal
	if CurrentHP < 0:
		CurrentHP = 0

func get_max_hp():
	# Returns unit's max hp
	return MaxHP



func get_current_ap():
	# Returns unit's current ap
	return CurrentAP

func set_current_ap(num):
	CurrentAP = num

func gain_ap(num):
	# Adds given num to unit's current ap
	CurrentAP = CurrentAP + num
	if CurrentAP > MaxAP:
		CurrentAP = MaxAP

func lose_ap(num):
	CurrentAP = CurrentAP - num
	if CurrentAP < 0:
		CurrentAP = 0

func lose_temp_ap(num):
	tempAP = tempAP - num
	if tempAP < 0:
		tempAP = 0

func reset_ap():
	CurrentAP = MaxAP
	tempAP = MaxAP

func get_max_ap():
	# Returns unit's max ap
	return MaxAP

func get_temp_ap():
	return tempAP



func get_current_init():
	# Returns unit's current initiative
	return CurrentInit

func set_current_init(num):
	# Sets unit's current initiative to given num
	CurrentInit = num

func get_true_init():
	# Returns unit's actual initiative stat
	return TrueInit



func get_faction():
	# Returns unit's alignment
	return Faction



func give_batonpass():
	storedBatonPass = BatonPass
	BatonPass = TS.BATONPASS

func set_has_acted():
	BatonPass = TS.ACTED

func reset_acted():
	BatonPass = TS.NOTACTED
	storedBatonPass = BatonPass

func get_batonpass():
	return BatonPass

func death():
	# Remove from unitLists
	# Refresh grid collision
	# Redraw init boxes
	# free from queue
	pass

func on_turn_start():
	print(self, " ", CurrentAP)
	SignalBus.changeButtonState.emit()
	start = grid.local_to_map(position)
	run_passives(methodType.ON_TURN_START, null)
	find_and_delete_passives()
	
	grid.update_grid_collision()
	
	print("	", Name, " turn start.")
	unique_turn_start()

func unique_turn_start():
	pass

func on_turn_end():
	print(self, " ", tempAP)
	if BatonPass == TS.BATONPASS:
		BatonPass = storedBatonPass
	else:
		set_has_acted()
	
	canMove = true
	SignalBus.hasMoved.emit(self,grid.local_to_map(position)) #NOT USED YET
	print("	", Name, " has acted.")
	unique_turn_end()

func unique_turn_end():
	SignalBus.endTurn.emit()

func on_execute(abilityUsed):
	if AutoloadMe.turnPointer == self and Faction == fac.ALLY:
		print(self, "Ability Aftermath")
		lose_temp_ap(abilityUsed.apCost)
		set_current_ap(get_temp_ap())
		AutoloadMe.turnPointer.start = grid.local_to_map(position)


func load_ability(name):
	var scene = load("res://Abilities/" + name + "/" + name + ".tscn")
	var sceneNode = scene.instantiate()
	add_child(sceneNode)
	print("Found ", name)
	return sceneNode

func add_passive(name):
	var scene = load("res://Passives/" + name + "/" + name + ".tscn")
	var sceneNode = scene.instantiate()
	add_child(sceneNode)
	passiveList.append(sceneNode)


# PROBABLY VERY JANK. MAY NEED TO CHANGE HOW RESIZING THE ARRAY IS HANDLED
func run_passives(mType, arg):
	for i in passiveList.size():
		if passiveList[i] != null and mType == passiveList[i].get_type():
			arg = passiveList[i].execute(arg)
	return arg

func find_and_delete_passives():
	# checks if passive countdown == 0
	# Removes passive from passiveList and signals them to delete themselves
	for i in passiveList.size():
		if i < passiveList.size() and passiveList[i] != null and passiveList[i].turnsRemaining <= 0:
			passiveList.remove_at(i)
			SignalBus.deletePassives.emit()
		else:
			i = 0 # THIS SEEMS TO WORK BUT I FEEL LIKE IT SHOULDN'T
