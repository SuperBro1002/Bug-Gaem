@tool
extends Node
class_name event_man

enum objectiveType {
	ROUTED,
	SURVIVAL
}

@export var currentObjective = objectiveType.ROUTED
@export var objectiveNum = 5
var isComplete = false

func _ready():
	SignalBus.connect("checkEvents", start_round_event_check)

func start_round_event_check():
	check_objective()
	main_round_events()
	global_side_round_events()
	local_side_round_events()
	activate_spawners()

# Handles narrative / Objective related events 
func main_round_events():
	pass

# Optional events that can happen on any map
func global_side_round_events():
	pass

# Optional events that happen on an individual map. Overriden by instances
func local_side_round_events():
	pass

# If statements checking round number and sending out signals to spawner groups
func activate_spawners():
	pass

# Match statements checking current progress
func objective_progress_events():
	pass

# Figure out exactly what kind of events we'll have. May or may not need post-ability/death/damaged/etc event functions


# Call functions depending on map objective
func check_objective():
	if currentObjective == objectiveType.ROUTED:
		isComplete = check_routed()
	elif currentObjective == objectiveType.SURVIVAL:
		isComplete = check_survival()

# Compares current enemy kill count with preset var
func check_routed():
	if AutoloadMe.deathCount <= objectiveNum:
		return true

# Checks current round # with preset var
func check_survival():
	if AutoloadMe.roundNum <= objectiveNum:
		return true
