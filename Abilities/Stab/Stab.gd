extends Ability_class

#var stab = load("res://Abilities/Stab/Stab.tscn")
#var Name = "Stab"
#
#@export var damage = 0
#@export var tileRange = 1
#@export var distanceRange = 1
#var actualRange = 64
#var caster
#var direction = null
#var clickedPos
#var targetUnits = []
#var targetTiles
#var clickedDistance
#@onready var abilityGrid = AutoloadMe.abilityRangeGrid

#func _ready():
#	damage = 0
#	tileRange = 1
#	distanceRange = 1
#	actualRange = 64

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	for i in targetUnits.size():
		targetUnits[i].lose_health(7)
	
	SignalBus.updateUI.emit(get_parent())
	SignalBus.abilityExecuted.emit()
