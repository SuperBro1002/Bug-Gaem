extends Node2D

@onready var myPos = position
@onready var spawnPos = myPos
@export var groupID = 0
@export var setName = ""
@export var setFileName = ""
@export var setHP = 1
@export var setAP = 1
@export var setInit = 1
@export var ability1 = ""
@export var ability2 = ""
@export var ability3 = ""
var setFaction = 1
var notObstructed = true

func _ready():
	SignalBus.connect("spawnGroup", spawn)
	set_visible(false)
	#spawn(1)

func spawn(idCalled):
	if idCalled != groupID:
		return
	
	var node = load("res://Scenes/enemy.tscn")
	var newUnit = node.instantiate()
	
	newUnit.name = setName
	newUnit.Name = setName
	newUnit.fileName = setFileName
	newUnit.MaxHP = setHP
	newUnit.CurrentHP = setHP
	newUnit.MaxAP = setAP
	newUnit.CurrentAP = setAP
	newUnit.tempAP = setAP
	newUnit.TrueInit = setInit
	newUnit.CurrentInit = setInit
	newUnit.SetAbility1 = ability1
	newUnit.SetAbility2 = ability2
	newUnit.SetAbility3 = ability3
	newUnit.Faction = setFaction
	print("OBI? ", notObstructed)
	if notObstructed:
		newUnit.position = myPos
	else:
		# Calc nearest open tile
		spawnPos = AutoloadMe.turnPointer.grid.flood_fill_first(AutoloadMe.turnPointer.grid.local_to_map(myPos))
		newUnit.position = spawnPos
	
	get_node("../Grid/InitManager/UnitManager").add_child(newUnit)
	newUnit.spawning_in()

# on_enter signal nodes to determine when new spawn needs to be set by changed notObstructed


func _on_area_entered(area):
	print("ENTERED")
	notObstructed = false

func _on_area_exited(area):
	notObstructed = true
