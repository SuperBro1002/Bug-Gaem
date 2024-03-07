extends Unit_class

var type = fac.ALLY
var ray
var animationSpeed = 3
var moving = false
var abilityQueued = null

var ability1 = load_ability("Stab")

@onready var tileSize = AutoloadMe.tile_size
@onready var astarGrid = AutoloadMe.astarGrid

# Called when the node enters the scene tree for the first time.
func _ready():	
	ray = $RayCast2D
	#init_stats(20,20,4,4,5,6,type,TS.NOTACTED)
	add_passive("Armor")
	add_passive("Armor")
	add_passive("Poison")
	add_passive("Poison")
	add_passive("Poison")
	position = position.snapped((Vector2.ZERO) * tileSize.x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func move(dir):
	
	match [dir == Vector2.RIGHT, dir == Vector2.LEFT]:
		[true,false]:
			$AnimatedSprite2D.set_flip_h(false)
		[false,true]:
			$AnimatedSprite2D.set_flip_h(true)
	ray.target_position = dir * tileSize.x
	ray.force_raycast_update()
	
	if !ray.is_colliding():
		end = grid.local_to_map(position) + Vector2i(dir) #WEIRD STUFF WITH GRID.LOCAL
		var pathArray = astarGrid.get_point_path(start, end)
		
		#NEED TEMP AP FOR CALCULATING WITH ACTION AFTERWARDS
		if get_current_ap() >= (pathArray.size() - 1):
			var tween = create_tween()
			tween.tween_property(self, "position",
			position + dir * tileSize.x, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)
			moving = true
			await tween.finished
			moving = false
	
	

func unique_turn_start():
	pass

func activate_ability1():
	abilityQueued = ability1
	ability1.queue(self)

func ability2():
	# Trigger second skill when in range
	pass
