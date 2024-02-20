extends Node2D

enum level {
	LEVEL1,
	LEVEL2,
	LEVEL3
}

var unitList = []
var map = []
var test

func _ready():
	var LD = $Level_Data
	
	map = LD.level_picker(level.LEVEL1)	#Grab the tile layout from $Level_Data
	
	$Grid.init_grid(map)	# Initializes the array into a grid with null unit data
	
	make_unit_list() # Puts all the unit nodes into a list
	
	
	$Grid.print_grid()
	$Grid.make_test_tiles()
	#$Grid.get_tile_character(Vector2(5,3))
	
	#print($Grid.get_unit_grid_pos(unitList[1]))
	
	assign_units_to_grid()
	#$Grid.get_tile_data(5,4)

func process():
	pass

# Prints the player's current grid coord when space is pressed
func _input(event):
	if event.is_action_pressed("Space"):
		print($Grid.get_unit_grid_pos($Grid/Ally))

# Manages ally turns; updates ap values with movement and actions, enables and disables actions dynamically. 
# Ends when current ap == 0 or player chooses to end. 
func ally_turn():
	pass

# Manages enemy turns; Handles their pathfinding and moves them accordingly. Also deals with actions.
# Ends when current enemy ap == 0 or no actions are available.
func enemy_turn():
	pass

# Checks to see if the objective(TBD) has been met.
func objective_check():
	pass

# Creates a list of all the units in a level
func make_unit_list():
	unitList.append($Grid/Ally)
	unitList.append($Grid/Enemy)

# Places the units in the unitList array in the appropriate grid array slot
func assign_units_to_grid():
	for i in unitList.size():
		$Grid.pair_unit_to_tile(unitList[i])
	#$Grid.print_grid()
