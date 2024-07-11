@tool
extends Node
class_name event_man

enum objectiveType {
	ROUTED,
	SURVIVAL,
	BOSS
}

@export var currentObjective = objectiveType.ROUTED
@export var objectiveNum = 5
var isComplete = false

func _ready():
	pass

func start_round_event_check():
	print("EVENTS")
	check_objective()
	activate_spawners()
	await get_tree().create_timer(1).timeout
	SignalBus.eventsDone.emit()

# If statements checking round number and sending out signals to spawner groups
func activate_spawners():
	pass

# Call functions depending on map objective
func check_objective():
	if currentObjective == objectiveType.ROUTED:
		check_routed()
	elif currentObjective == objectiveType.SURVIVAL:
		isComplete = check_survival()
	elif currentObjective == objectiveType.BOSS:
		check_boss_routed()

# Compares current enemy kill count with preset var
func check_routed():
	if AutoloadMe.deathCount >= objectiveNum:
		get_tree().quit()

# Checks current round # with preset var
func check_survival():
	if AutoloadMe.roundNum >= objectiveNum:
		return true

func check_boss_routed():
	if AutoloadMe.bossdead == true:
		pass
		##PUT STUFF HERE
