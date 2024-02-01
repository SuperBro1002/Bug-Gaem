extends TileMap

var tile_size = tile_set.tile_size
var half_tile_size = tile_size / 2

var grid_size = Vector2(10,10)
var grid = []
var i = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Generates the grid array
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(i)
			i += 1
	init_grid()
	print (grid)
	
	var Player = get_node("Player")
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
