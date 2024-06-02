extends Node2D

@export var UnitSpawn = "Robopoly"
@onready var myPos = position
@onready var spawnPos = myPos
@onready var areaType = "spawner"
@export var groupID = 0

var setFaction = 1
var notObstructed = true

func _ready():
	SignalBus.connect("spawnGroup", spawn)
	set_visible(false)

func spawn(idCalled):
	if idCalled != groupID:
		return
	
	var node = load("res://Scenes/Units/" + UnitSpawn + ".tscn")
	var newUnit = node.instantiate()
	
	if notObstructed:
		print("Not obtructed")
		newUnit.position = myPos
	else:
		# Calc nearest open tile
		print("obtructed")
		spawnPos = AutoloadMe.turnPointer.grid.flood_fill_first(AutoloadMe.turnPointer.grid.local_to_map(myPos))
		newUnit.position = spawnPos
	
	get_node("../Grid/InitManager/UnitManager").add_child(newUnit)
	newUnit.spawning_in()

func _on_area_entered(_area):
	print("ENTERED")
	notObstructed = false

func _on_area_exited(_area):
	if AutoloadMe.turnPointer.grid.is_tile_open(position):
		notObstructed = true
