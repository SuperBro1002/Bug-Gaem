extends TileMap

var tile_size = tile_set.tile_size
var half_tile_size = tile_size / 2

var grid_size = Vector2(10,10)
var grid = []
var i = 0

# Creates states for different terrain types.
enum Terrain {
	EMPTY,
	WALL,
	SHORT_WALL
}

enum faction {
	ALLY,
	ENEMY
}

var wallpiece = preload("res://Wall.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Generates an empty grid
func gen_grid_array():
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)

# Initialize the grid's starting values to the given parameters.
func init_grid(gridArray):
	grid = gridArray
	
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			grid[x][y] = [grid[x][y],null] # Sets every position on the array to have an array containing the terrain id and a null spot for unit data

# Get the unit on a given tile
func get_tile_character(Vector2):
	print("Unit @ 5,3: ", grid[Vector2.x][Vector2.y][1])
	return grid[Vector2.x][Vector2.y][1]

# Returns the parameter's relative position in terms of the grid
func get_unit_grid_pos(unit):
	var pos = unit.position
	return local_to_map(pos)

# Places the parameter into the unit data slot of the tile the unit is currently at
func pair_unit_to_tile(unit):
	var grid_pos = get_unit_grid_pos(unit)
	grid[grid_pos.y][grid_pos.x][1] = unit

# Prints the contents of the given tile
func get_tile_data(y,x):
	print ("TILE HAS ", grid[x][y])
	print(grid[x][y][1].get_current_hp())

# Checks if the cell in the given direction has no unit in it
func is_cell_vacant(pos, direction):
	# Return true if cell is vacant and standable, otherwise return false
	var try_grid_pos = local_to_map(pos) + Vector2i(direction)
	
	if try_grid_pos.x < grid_size.x and try_grid_pos.x >= 0:
		if try_grid_pos.y < grid_size.y and try_grid_pos.y >= 0:
			return true if grid[try_grid_pos.y][try_grid_pos.x][0] == 0 && grid[try_grid_pos.y][try_grid_pos.x][1] == null else false
	return false

# Removes unit from previous grid position and places them in the new position
func update_unit_pos(child, dir):
	# Move a child to a new position in the grid array
	# Returns the new target position of child
	var grid_pos = local_to_map(child.position)
	grid[grid_pos.y][grid_pos.x][1] = null
	
	var new_grid_pos = grid_pos + Vector2i(child.inputs[dir])
	grid[new_grid_pos.y][new_grid_pos.x][1] = child
	
	#var target_pos = Vector2i(map_to_local(new_grid_pos)) + half_tile_size
	#return target_pos
	#print(grid)

func count_down():
	# Decrement any timers 
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# TESTING FUNCTIONS


# Draws squares to show grid tile positions
func make_test_tiles():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var grid_pos_test1 = Vector2(x,y)
			var local_pos1 = map_to_local(grid_pos_test1) 
			var new_wall = wallpiece.instantiate()
			new_wall.position = local_pos1
			add_child(new_wall)

# Outputs the grid in the console.
func print_grid():
	print(grid)

# Prints the parameter's position
func print_unit_coord(child):
	print(local_to_map(child.position))

# Prints the data of the parameter's tile object
func print_current_tile(child):
	var testx = local_to_map(child.position)
	#print (testx.x)
	print(grid[testx.y][testx.x])

# Prints all the unit data in the grid
func print_all_tile_characters():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			print(grid[x][y][1])

