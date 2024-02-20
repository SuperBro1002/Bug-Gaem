extends Unit_class

var screenSize

var animationSpeed = 3
var moving = false
var tile_size = 64
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

var type
var grid

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size
	grid = get_parent()
	type = grid.faction.ALLY
	init_stats(1,2,3,4,5,6,type)
	
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	grid.print_unit_coord(self)
#	grid.print_current_tile(self)
#	print("  ")
	print(grid)

func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	if grid.is_cell_vacant(position, inputs[dir]):
		grid.update_unit_pos(self, dir)
		#position += inputs[dir] * tile_size
		var tween = create_tween()
		tween.tween_property(self, "position",
		position + inputs[dir] * tile_size, 1.0/animationSpeed).set_trans(Tween.TRANS_SINE)
		moving = true
		await tween.finished
		moving = false


func ability1():
	# Trigger first skill when in range
	pass

func ability2():
	# Trigger second skill when in range
	pass

func interact():
	# Interact with environmental objects
	pass
