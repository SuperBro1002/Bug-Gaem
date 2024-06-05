extends Unit_class

var type = fac.ALLY
var ray
var moving = false
var abilityQueued = null
var pathArray
var overlapTween
var isDown = false

@onready var ability1 = load_ability(SetAbility1)
@onready var ability2 = load_ability(SetAbility2)
@onready var ability3 = load_ability(SetAbility3)

@onready var tileSize = AutoloadMe.tile_size
@onready var astarGrid = AutoloadMe.movementGrid

# Called when the node enters the scene tree for the first time.
func _ready():
	print("READY")
	SignalBus.connect("ability",toggle_unit_ability)
	ray = $RayCast2D
	# NOTE: NEED TO FIGURE OUT A WAY TO SET INHERENT PASSIVES FOR DIFFERENT UNITS IN EDITOR
#	add_passive("Trap")
#	add_passive("Poison")
	position = position.snapped((Vector2.ZERO) * tileSize.x)

func clone(OGUnit):
	print("CLONE")
	OG = OGUnit
	set_visible(false)
	isPossessed = true
	Name = OGUnit.Name
	fileName = OGUnit.fileName
	set_name("Possessed " + Name)
	MaxHP = OGUnit.MaxHP
	CurrentHP = OGUnit.CurrentHP
	MaxAP = OGUnit.MaxAP
	CurrentAP = MaxAP
	TrueInit = OGUnit.TrueInit
	CurrentInit = OGUnit.CurrentInit
	SetAbility1 = OGUnit.SetAbility1
	SetAbility2 = "Heal"
	SetAbility3 = "Sting"
	
	#ability1 = load_ability(SetAbility1)
	ability2 = load_ability(null)
	ability3 = load_ability(null)
	
	Faction = fac.ALLY
	delete_floating_hp()
	make_floating_hp()
	SignalBus.updateFloatingHP.emit(self)
	BatonPass = TS.BATONPASS
	tempAP = MaxAP
	position = OGUnit.position
	start = grid.convert_to_map(OGUnit.position)
	end = grid.convert_to_map(OGUnit.position)
	abilityStartPoint = grid.convert_to_map(OGUnit.position)
	get_node("AnimatedSprite2D:sprite_frames").set_sprite_frames(load("res://Scenes/Sprite Frames/" + OGUnit.fileName + ".tres"))
	get_node(".:Scale").set_scale(Vector2(1,1))
	get_node("AnimatedSprite2D:Scale").set_scale(Vector2(2,2))
	add_passive("Doom")
	await get_tree().create_timer(0.5).timeout
	set_visible(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func get_reachable_tiles():
	return grid.flood_fill_movement(grid.map_to_local(start), CurrentAP)

func move(dir):
	if isDown: return
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
			pathArray = astarGrid.get_point_path(start, end)
			
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

func on_turn_start():
	pathArray = null
	if AutoloadMe.passingUnit != null:
		var prevUnit = AutoloadMe.passingUnit
		inherit_ap(prevUnit.CurrentAP)
		tempAP = CurrentAP
		prevUnit.CurrentAP = 0
		prevUnit.tempAP = 0
		AutoloadMe.passingUnit = null
	
	if Faction == fac.ENEMY:
		SignalBus.showUI.emit()
	
	tempAP = CurrentAP
	start = grid.local_to_map(position)
	abilityStartPoint = grid.convert_to_map(position)
	SignalBus.updateUI.emit(self)
	SignalBus.startAnimate.emit(self)
	AutoloadMe.set_process_unhandled_input(false)
	print(self, " ", CurrentAP)
	print("UnitList: ", AutoloadMe.globalUnitList)
	SignalBus.wipeTilePaths.emit(null)
	await get_tree().create_timer(1).timeout
	SignalBus.startTurn.emit()
	SignalBus.changeButtonState.emit()
	run_passives(methodType.ON_TURN_START, null)
	find_and_delete_passives()
	
	grid.update_grid_collision()
	SignalBus.updateUI.emit(self)
	print("	", Name, " turn start.")
	unique_turn_start()

func unique_turn_start():
	if isDown: MaxAP = 0
	SignalBus.changeButtonState.emit()
	SignalBus.updateUI.emit(self)

func unique_turn_end():
	set_current_ap(get_temp_ap())
	print("	 ", Name, " ", TS)
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
		SignalBus.changeControls.emit()
		SignalBus.changeButtonState.emit()
	elif self != AutoloadMe.turnPointer and get_parent() == area.get_parent():
		if overlapTween:
			overlapTween.kill()
		overlapTween = create_tween()
		overlapTween.tween_property(self, "modulate:a", 0, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)

func _on_area_exited(area):
	if self == AutoloadMe.turnPointer and get_parent() == area.get_parent() and !has_overlapping_areas():
		AutoloadMe.notOverlapped = true
		SignalBus.changeControls.emit()
		SignalBus.changeButtonState.emit()
	elif self != AutoloadMe.turnPointer and get_parent() == area.get_parent() and !has_overlapping_areas():
		if overlapTween:
			overlapTween.kill()
		overlapTween = create_tween()
		overlapTween.tween_property(self, "modulate:a", 1, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation != "Idle":
		$AnimatedSprite2D.play("Idle")
