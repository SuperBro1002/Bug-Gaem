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
	ON_TURN_START
}

var passiveList = []
var incoming_dmg_type = null # pierce, null

@export var Name = "Default"
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
@onready var end = grid.convert_to_map(position)

func _enter_tree():
	#init_stats(MaxHP, CurrentHP, MaxAP, CurrentAP, TrueInit, CurrentInit)
	pass

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

func gain_ap(num):
	# Adds given num to unit's current ap
	CurrentAP = CurrentAP + num
	if CurrentAP > MaxAP:
		CurrentAP = MaxAP

func lose_ap(num):
	CurrentAP = CurrentAP - num
	if CurrentAP < 0:
		CurrentAP = 0

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
	BatonPass = TS.BATONPASS

func set_has_acted():
	BatonPass = TS.ACTED

func reset_acted():
	BatonPass = TS.NOTACTED

func get_batonpass():
	return BatonPass



func on_turn_start():
	start = grid.local_to_map(position)
	run_passives(methodType.ON_TURN_START, null)
	find_and_delete_passives()
	
	grid.update_grid_collision()
	
	print("	", Name, " turn start.")
	unique_turn_start()

func unique_turn_start():
	pass

func on_turn_end():
	set_has_acted()
	SignalBus.hasMoved.emit(self,grid.local_to_map(position)) #NOT USED YET
	reset_ap()
	print("	", Name, " has acted.")
	SignalBus.endTurn.emit()



func load_ability(name):
	var scene = load("res://Abilities/" + name + "/" + name + ".tscn")
	var sceneNode = scene.instantiate()
	add_child(sceneNode)
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
			i = 0
