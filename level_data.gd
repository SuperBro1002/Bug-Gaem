extends Node2D

enum level {
	LEVEL1,
	LEVEL2,
	LEVEL3
}

func _ready():
	pass

# Determines which grid to use from the parameter passed.
func level_picker(currentLevel):
	if currentLevel == level.LEVEL1:
		return [[1,1,1,1,1,1,1,1,1,1],
				[1,0,0,0,0,0,0,0,0,1],
				[1,0,0,1,1,0,0,0,0,1],
				[1,0,0,0,0,0,0,0,0,1],
				[1,0,0,0,0,0,1,1,0,1],
				[1,0,0,0,0,0,1,1,0,1],
				[1,0,0,0,0,0,0,0,0,1],
				[1,0,0,0,0,0,0,0,0,1],
				[1,0,0,0,0,0,0,0,0,1],
				[1,1,1,1,1,1,1,1,1,1]]
	else: return null

# Returns the unit start positions for the given level
func start_pos(currentLevel):
	pass

# Returns a list of units for the given level
func unit_data(currentLevel):
	pass

