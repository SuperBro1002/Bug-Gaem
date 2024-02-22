extends Unit_class



var type
var ray
var animationSpeed = 3
var moving = false
var grid

@onready var tileSize = AutoloadMe.tile_size

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = get_parent()
	ray = $RayCast2D
	init_stats(1,2,3,4,5,6,type)
	
	position = position.snapped((Vector2.ZERO) * tileSize.x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	ray.target_position = inputs[dir] * tileSize.x
	ray.force_raycast_update()
	
	if !ray.is_colliding():
		
		grid.end = grid.local_to_map(position) + Vector2i(inputs[dir])
		var pathArray = grid.astarGrid.get_point_path(grid.start, grid.end)
		
		
		#NEED TEMP AP FOR CALCULATING WITH ACTION AFTERWARDS
		if get_current_ap() >= (pathArray.size() - 1):
			var tween = create_tween()
			tween.tween_property(self, "position",
			position + inputs[dir] * tileSize.x, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)
			moving = true
			await tween.finished
			moving = false
		
		
		#print(grid.astarGrid.get_point_path(grid.start, grid.end))

#func _draw():
#	draw_grid()
#	draw_rect(Rect2(start * tileSize, tileSize), Color.GREEN_YELLOW)
#	draw_rect(Rect2(end * tileSize, tileSize), Color.ORANGE_RED)
#	$Line2D.points = PackedVector2Array(astarGrid.get_point_path(start, end))
#
#func draw_grid():
#	for x in gridSize.x + 1:
#		draw_line(Vector2(x * tileSize.x, 0),
#			Vector2(x * tileSize.x, gridSize.y * tileSize.y),
#			Color.DARK_GRAY, 2.0)
#	for y in gridSize.y + 1:
#		draw_line(Vector2(0, y * tileSize.y),
#			Vector2(gridSize.x * tileSize.x, y * tileSize.y),
#			Color.DARK_GRAY, 2.0)
#

#func update_path():
#	$Line2D.points = PackedVector2Array(astarGrid.get_point_path(start, end))


#func initialize_grid():
#	gridSize = Vector2i(get_viewport_rect().size) / tileSize
#	astarGrid.size = gridSize
#	astarGrid.cell_size = tileSize
#	astarGrid.offset = tileSize / 2
#	astarGrid.update()
#	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

#func fill_walls():
#	for x in gridSize.x:
#		for y in gridSize.y:
#			if astarGrid.is_point_solid(Vector2i(x, y)):
#				draw_rect(Rect2(x * tileSize.x, y * tileSize.y, tileSize.x, tileSize.y), Color.DARK_GRAY)

#func _input(event):
#	if event is InputEventMouseButton:
## Add/remove wall
#		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
#			var pos = Vector2i(event.position) / tileSize
#			if astarGrid.is_in_boundsv(pos):
#				astarGrid.set_point_solid(pos, not astarGrid.is_point_solid(pos))
#				update_path()
#				queue_redraw()


func ability1():
	# Trigger first skill when in range
	pass

func ability2():
	# Trigger second skill when in range
	pass
