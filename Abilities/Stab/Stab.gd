extends Node

var stab = load("res://Abilities/Stab/Stab.tscn")

@export var damage = 0
@export var tileRange = 1
var actualRange = 64
var caster
var direction = null

func _ready():
	range_convert()
	#print($Hitbox.target_position)

func range_convert():
	actualRange = tileRange * AutoloadMe.tile_size.x
	$Hitbox.target_position = Vector2(0, actualRange)

func queue():
	# Use AStar to calc valid AOE range
	# Use AOE box to calc all targets
	# Use rays to check LOS
	# Use AStar to calc all valid targets
	pass

func execute(_targetUnits, _targetTiles):
	# for eavery target in target units[]
		# For each target in target_tiles[]
	pass

