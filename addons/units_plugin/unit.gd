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

#enum methodType {
#	"GAIN_HEALTH",
#	"LOSE_HEALTH",
#	"GAIN_AP",
#	"LOSE_AP",
#	"ON_TURN_START"
#}

var passiveList = []


@export var ID = 0
@export var MaxHP = 20
@export var CurrentHP = 20
@export var MaxAP = 5
@export var CurrentAP = 5
@export var TrueInit = 7
@export var CurrentInit = 3
@export var Faction = fac.NONE
@export var BatonPass = TS.NOTACTED

@onready var grid = get_parent().get_parent().get_parent()

@onready var start = grid.convert_to_local(position)
@onready var end = grid.convert_to_local(position)

func _enter_tree():
	#init_stats(MaxHP, CurrentHP, MaxAP, CurrentAP, TrueInit, CurrentInit)
	pass

func onTurnStart():
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

func gain_health(num):
	# Adds given num to unit's current hp
	CurrentHP = CurrentHP + num
	if CurrentHP > MaxHP:
		CurrentHP = MaxHP

func lose_health(dmgVal):
	
	dmgVal = run_passives("LOSE_HEALTH", dmgVal)
	CurrentHP = CurrentHP - dmgVal
	if CurrentHP < 0:
		CurrentHP = 0
	print("NEW HEALTH: ", CurrentHP)

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

func get_max_ap():
	# Returns unit's max ap
	return MaxAP



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



func on_turn_end():
	pass

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

func run_passives(mType, arg):
	for i in passiveList.size():
		if mType == passiveList[i].get_type():
			arg = passiveList[i].execute(arg)
	return arg

