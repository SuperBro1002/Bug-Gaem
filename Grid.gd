extends TileMap

var tile_size = tile_set.tile_size
var half_tile_size = tile_size / 2

var grid_size = Vector2(10,10)
var grid = []
var i = 0

# Creates states for different terrain types.
enum Terrain{
	EMPTY,
	WALL,
	SHORT_WALL
}

var wallpiece = preload("res://Wall.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Generates the grid array
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
			i += 1
	#init_grid()
	print (grid)
	
#	var grid_pos_test = Vector2(3,9)
#	var local_pos = map_to_local(grid_pos_test) 
	
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var grid_pos_test = Vector2(x,y)
			var local_pos = map_to_local(grid_pos_test) 
			var new_wall = wallpiece.instantiate()
			new_wall.position = local_pos
			add_child(new_wall)
	
#	var new_wall = wallpiece.instantiate()
#	new_wall.position = local_pos
	#print(grid_pos_test)
	#print(local_pos)

	
	#add_child(new_wall)
	
	var Player = get_node("Player")
	var testMaxHP = Player.get_max_hp()
	print(testMaxHP)
	#var StartingPos = update_unit_pos(Player)

func init_grid():
	# Initialize the grid array's starting values
	grid = [[1,1,1,1,1,1,1,1,1,1],
			[1,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,1],
			[1,0,0,0,0,0,0,0,0,1],
			[1,1,1,1,1,1,1,1,1,1]]

func draw_grid():
	# Draws the grid
	pass

func is_cell_vacant():
	# Return true if cell is vacant, otherwise return false
	pass

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
