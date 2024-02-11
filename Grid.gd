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

var wallpiece = preload("res://Wall.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Generates the grid array
#	for x in range(grid_size.x):
#		grid.append([])
#		for y in range(grid_size.y):
#			grid[x].append(null)
#			i += 1
#	print (grid)
	
#	var grid_pos_test = Vector2(3,9)
#	var local_pos = map_to_local(grid_pos_test)
	
#	for x in range(grid_size.x):
#		for y in range(grid_size.y):
#			var grid_pos_test1 = Vector2(x,y)
#			var local_pos1 = map_to_local(grid_pos_test1) 
#			var new_wall = wallpiece.instantiate()
#			new_wall.position = local_pos1
#			add_child(new_wall)
	
	# Create a new wall at a given coordinate and print the map and local coords 
#	var new_wall = wallpiece.instantiate()
#	new_wall.position = local_pos
#	print(grid_pos_test)
#	print(local_pos)
#	add_child(new_wall)
	
#	var Player = get_node("Player")
#	var testMaxHP = Player.get_max_hp()
#	print(testMaxHP)
	#var StartingPos = update_unit_pos(Player)
	pass

# Draws squares to show grid tile positions
func make_test_tiles():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var grid_pos_test1 = Vector2(x,y)
			var local_pos1 = map_to_local(grid_pos_test1) 
			var new_wall = wallpiece.instantiate()
			new_wall.position = local_pos1
			add_child(new_wall)

# Generates an empty grid
func gen_grid_array():
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)

# Initialize the grid's starting values to the given parameters.
func init_grid(gridArray):
	grid = gridArray
	
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			grid[x][y] = [grid[x][y],null] # Sets every position on the array to have an array containing the terrain id and a null spot for unit data

func print_all_tile_characters():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			print(grid[x][y][1])

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
	grid[grid_pos.x][grid_pos.y][1] = unit

func get_tile_data(x,y):
	print ("TILE HAS ", grid[x][y])
	print(grid[x][y][1].get_current_hp())

# Outputs the grid in the console.
func print_grid():
	print(grid)

func draw_grid():
	# Draws the grid
	pass

func is_cell_vacant(pos):
	# Return true if cell is vacant and standable, otherwise return false
	var isOpen = false
	var grid_pos = local_to_map(pos)
	
	if grid_pos.x < grid_size.x and grid_pos.x >= 0:
		if grid_pos.y < grid_size.y and grid_pos.y >= 0:
			return true if grid[grid_pos.x][grid_pos.y][0] == 0 && grid[grid_pos.x][grid_pos.y][1] == null else false

func update_unit_pos(child, new_pos):
	# Move a child to a new position in the grid array
	# Returns the new target position of child
	pass

func count_down():
	# Decrement any timers 
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
