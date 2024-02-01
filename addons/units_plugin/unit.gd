@tool
extends CharacterBody2D
class_name Unit_class

@export var MaxHP = 20
@export var CurrentHP = 20
@export var MaxAP = 5
@export var CurrentAP = 5
@export var TrueInit = 7
@export var CurrentInit = 3

func _enter_tree():
	#init_stats(MaxHP, CurrentHP, MaxAP, CurrentAP, TrueInit, CurrentInit)
	pass

func init_stats(max_hp, current_hp, max_ap, current_ap, True_init, current_init):
	# Assign the given values to their respective stats
	MaxHP = max_hp
	CurrentHP = current_hp
	MaxAP = max_ap
	CurrentAP = current_ap
	TrueInit = True_init
	CurrentInit = current_init

func get_current_hp():
	# Returns unit's current hp
	return CurrentHP

func get_max_hp():
	# Returns unit's max hp
	return MaxHP

func get_current_ap():
	# Returns unit's current ap
	return CurrentAP

func get_max_ap():
	# Returns unit's max ap
	return MaxAP

func get_current_init():
	# Returns unit's current initiative
	return CurrentInit

func get_true_init():
	# Returns unit's actual initiative stat
	return TrueInit
