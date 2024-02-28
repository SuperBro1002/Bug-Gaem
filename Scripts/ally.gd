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
	init_stats(1,2,4,4,5,6,type,0)
	
	position = position.snapped((Vector2.ZERO) * tileSize.x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func move(dir):
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

func onTurnStart():
	start = grid.local_to_map(position)
	print("ALLY TURN START")

func on_turn_end():
	set_has_acted()
	SignalBus.hasMoved.emit(self,grid.local_to_map(position)) #NOT USED YET
	reset_ap()
	SignalBus.endTurn.emit()

func activate_ability1():
	abilityQueued = ability1
	ability1.queue(self)

func ability2():
	# Trigger second skill when in range
	pass
