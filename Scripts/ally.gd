extends Unit_class

var type = fac.ALLY
var ray
var animationSpeed = 4
var moving = false
var abilityQueued = null

@onready var ability1 = load_ability(SetAbility1)
@onready var ability2 = load_ability(SetAbility2)
@onready var ability3 = load_ability(SetAbility3)

@onready var tileSize = AutoloadMe.tile_size
@onready var astarGrid = AutoloadMe.movementGrid

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("ability",toggle_unit_ability)
	ray = $RayCast2D
	# NOTE: NEED TO FIGURE OUT A WAY TO SET INHERENT PASSIVES FOR DIFFERENT UNITS IN EDITOR
#	add_passive("Trap")
#	add_passive("Poison")
	
	position = position.snapped((Vector2.ZERO) * tileSize.x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func get_reachable_tiles():
	return grid.flood_fill_movement(grid.map_to_local(start), CurrentAP)

func move(dir):
	if canMove == true:
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
			
			if get_current_ap() >= (pathArray.size() - 1):
				var tween = create_tween()
				tween.tween_property(self, "position",
				position + dir * tileSize.x, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)
				tempAP = self.get_current_ap() - pathArray.size() + 1
				SignalBus.changeButtonState.emit()
				SignalBus.updateUI.emit(self)
				moving = true
				await tween.finished
				moving = false
				abilityStartPoint = grid.convert_to_map(position)

func unique_turn_start():
	SignalBus.changeButtonState.emit()
	SignalBus.updateUI.emit(self)

func unique_turn_end():
	set_current_ap(get_temp_ap())
	SignalBus.endTurn.emit()

func activate_ability(num):
	if num == 1:
		abilityQueued = ability1
	elif num == 2:
		abilityQueued = ability2
	elif num == 3:
		abilityQueued = ability3

func toggle_unit_ability(num, state):
	if state == true:
		activate_ability(num)
		SignalBus.abilityIsQueued.emit()
	else:
		deactivate_ability()

func deactivate_ability():
	abilityQueued = null
	AutoloadMe.validQueue = false


func _on_area_entered(area):
	if self == AutoloadMe.turnPointer and get_parent() == area.get_parent():
		AutoloadMe.notOverlapped = false
		SignalBus.changeButtonState.emit()

func _on_area_exited(area):
	if self == AutoloadMe.turnPointer and get_parent() == area.get_parent() and !has_overlapping_areas():
		print(get_overlapping_areas(), !has_overlapping_areas())
		AutoloadMe.notOverlapped = true
		SignalBus.changeButtonState.emit()
		print(self ," Is it clear? ", AutoloadMe.notOverlapped)
