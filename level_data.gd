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
				[1,0,0,0,0,0,0,0,0,1],
				[1,0,1,0,0,0,0,0,0,1],
				[1,0,1,0,0,0,0,0,0,1],
				[1,0,0,0,0,0,0,0,0,1],
				[1,0,0,0,1,1,0,0,0,1],
				[1,0,0,0,1,1,0,0,0,1],
				[1,0,0,0,0,0,0,0,0,1],
				[1,1,1,1,1,1,1,1,1,1]]
	else: return null


