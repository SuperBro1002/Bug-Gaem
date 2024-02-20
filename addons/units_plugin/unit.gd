@tool
extends Area2D
class_name Unit_class

enum fac {
	ALLY,
	ENEMY
}

@export var ID = 0
@export var MaxHP = 20
@export var CurrentHP = 20
@export var MaxAP = 5
@export var CurrentAP = 5
@export var TrueInit = 7
@export var CurrentInit = 3
@export var Faction = fac.ALLY

func _enter_tree():
	#init_stats(MaxHP, CurrentHP, MaxAP, CurrentAP, TrueInit, CurrentInit)
	pass

func init_stats(max_hp, current_hp, max_ap, current_ap, True_init, current_init, faction):
	# Assign the given values to their respective stats
	MaxHP = max_hp
	CurrentHP = current_hp
	MaxAP = max_ap
	CurrentAP = current_ap
	TrueInit = True_init
	CurrentInit = current_init
	Faction = faction

func get_id():
	# Returns the id of this unit
	return ID


func get_current_hp():
	# Returns unit's current hp
	return CurrentHP

func add_current_hp(num):
	# Adds given num to unit's current hp
	CurrentHP = CurrentHP + num


func get_max_hp():
	# Returns unit's max hp
	return MaxHP


func get_current_ap():
	# Returns unit's current ap
	return CurrentAP

func add_current_ap(num):
	# Adds given num to unit's current ap
	CurrentAP = CurrentAP + num


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
