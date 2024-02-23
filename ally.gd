extends Unit_class

var type
var ray
var animationSpeed = 3
var moving = false

@onready var tileMap = $Grid
@onready var tileSize = AutoloadMe.tile_size
@onready var astarGrid = AutoloadMe.astarGrid

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

# Called when the node enters the scene tree for the first time.
func _ready():
	ray = $RayCast2D
	init_stats(1,2,3,4,5,6,type)
	print(grid.get_used_rect()) #HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
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
		
		end = grid.local_to_map(position) + Vector2i(inputs[dir]) #WEIRD STUFF WITH GRID.LOCAL
		var pathArray = astarGrid.get_point_path(start, end)
		
		#NEED TEMP AP FOR CALCULATING WITH ACTION AFTERWARDS
		if get_current_ap() >= (pathArray.size() - 1):
			var tween = create_tween()
			tween.tween_property(self, "position",
			position + inputs[dir] * tileSize.x, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)
			moving = true
			await tween.finished
			moving = false

func ability1():
	# Trigger first skill when in range
	pass

func ability2():
	# Trigger second skill when in range
	pass
