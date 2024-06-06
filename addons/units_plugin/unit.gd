@tool
extends Area2D
class_name Unit_class

enum fac {
	ALLY,
	ENEMY,
	NONE,
	OBSTACLE
}

enum TS {
	BATONPASS,
	ACTED,
	NOTACTED
}

enum methodType {
	GAIN_HEALTH,
	LOSE_HEALTH,
	GAIN_AP,
	LOSE_AP,
	ON_TURN_START,
	ON_TURN_END,
	IMMEDIATE_PERSISTING,
	ABILITY_EXECUTE
}

var passiveList = []
var incoming_dmg_type = null # pierce, null

@export var Name = "Default"
@export var fileName = "Default"
@export var MaxHP = 20
@onready var CurrentHP = MaxHP
@export var MaxAP = 5
@onready var CurrentAP = MaxAP
@export var TrueInit = 7
@export var InitVariance = 0
@onready var CurrentInit = TrueInit
@export var SetAbility1 = "Tackle"
@export var SetAbility2 = "Tackle"
@export var SetAbility3 = "Tackle"
@export var Faction = fac.NONE
@export var BatonPass = TS.NOTACTED
@export var Controllable = true

@onready var tempAP = get_max_ap()
@onready var grid = find_parent("Grid")
@onready var start = grid.convert_to_map(position)
@onready var abilityStartPoint = grid.convert_to_map(position)
@onready var end = grid.convert_to_map(position)
@onready var areaType = "unit"

var isPossessed #= false
var OG
var myHPBar
var myInitBox
var canMove = true
var storedBatonPass = TS.NOTACTED
var glowTween
var animationSpeed = 4
var isDown = false

func _enter_tree():
	print("TREE")
	#print(isPossessed, " <-----------------------")
	SignalBus.connect("abilityExecuted",on_execute)
	SignalBus.connect("highlightUnit", glow)
	#await get_tree().create_timer(3).timeout
	print(Name, " MY ABILITY IS ", SetAbility1)
	vary_init()
	make_floating_hp()
	make_floating_ap()

func _ready():
	print("READY")

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
	SetAbility2 = null
	SetAbility3 = null
	
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

func make_floating_hp():
	var scene = load("res://Scenes/floating_hp_bar.tscn")
	var sceneNode = scene.instantiate()
	add_child(sceneNode)
 
func delete_floating_hp():
	myHPBar.queue_free()

func make_floating_ap():
	var scene = load("res://Scenes/floating_ap.tscn")
	var sceneNode = scene.instantiate()
	add_child(sceneNode)


func init_stats(max_hp, current_hp, max_ap, current_ap, True_init, current_init, faction, bp):
	# Assign the given values to their respective stats
	MaxHP = max_hp
	CurrentHP = current_hp
	MaxAP = max_ap
	CurrentAP = current_ap
	TrueInit = True_init
	CurrentInit = current_init
	Faction = faction
	BatonPass = bp

func set_name(str):
	Name = str

func set_fileName(str):
	fileName = str

func get_current_hp():
	# Returns unit's current hp
	return CurrentHP

func gain_health(recoverVal):
	# Adds given num to unit's current hp
	recoverVal = run_passives(methodType.GAIN_HEALTH, recoverVal)
	CurrentHP = CurrentHP + recoverVal
	if CurrentHP > MaxHP:
		CurrentHP = MaxHP
	SignalBus.updateFloatingHP.emit(self)

func lose_health(dmgVal):
	dmgVal = run_passives(methodType.LOSE_HEALTH, dmgVal)
	if AutoloadMe.currentAbility != null:
		print("Losing HP: ", self , ": ", Name)
		print(AutoloadMe.currentAbility)
		dmgVal *= AutoloadMe.currentAbility.dmgMod
	CurrentHP = CurrentHP - dmgVal
	incoming_dmg_type = null
	if !isDown: animated_Damaged()
	if CurrentHP < 0:
		CurrentHP = 0
	SignalBus.updateFloatingHP.emit(self)
	await SignalBus.HpUiFinish
	if CurrentHP == 0:
		if Faction == 0:
			if isPossessed == true: delete(self)
			if isDown: return
			get_node("AnimatedSprite2D").play("Downed")
			add_passive("Down")
			return
		delete(self)

func passive_lose_health(dmgVal):
	dmgVal = run_passives(methodType.LOSE_HEALTH, dmgVal)
	print("Losing HP through a passive: ", self , ": ", Name)
	print(AutoloadMe.currentAbility)
	CurrentHP = CurrentHP - dmgVal
	incoming_dmg_type = null
	animated_Damaged()
	if CurrentHP < 0:
		CurrentHP = 0
		
	SignalBus.updateFloatingHP.emit(self)
	await SignalBus.HpUiFinish
	
	if CurrentHP == 0:
		if Faction == fac.ALLY and isPossessed == false:
			print(Name, " downed.")
			get_node("AnimatedSprite2D").play("Downed")
			add_passive("Down")
		else: delete(self)



func get_max_hp():
	# Returns unit's max hp
	return MaxHP



func get_current_ap():
	# Returns unit's current ap
	return CurrentAP

func set_current_ap(num):
	CurrentAP = num
	if CurrentAP > MaxAP:
		CurrentAP = MaxAP

func inherit_ap(num):
	if num > CurrentAP:
		CurrentAP = num
		if CurrentAP > MaxAP:
			CurrentAP = MaxAP

func gain_ap(num):
	# Adds given num to unit's current ap
	CurrentAP = CurrentAP + num
	if CurrentAP > MaxAP:
		CurrentAP = MaxAP

func lose_ap(num):
	CurrentAP = CurrentAP - num
	if CurrentAP < 0:
		CurrentAP = 0

func lose_temp_ap(num):
	tempAP = tempAP - num
	if tempAP < 0:
		tempAP = 0

func reset_ap():
	CurrentAP = MaxAP
	tempAP = MaxAP

func get_max_ap():
	# Returns unit's max ap
	return MaxAP

func get_temp_ap():
	return tempAP



func get_current_init():
	# Returns unit's current initiative
	return CurrentInit

func set_current_init(num):
	# Sets unit's current initiative to given num
	CurrentInit = num

func get_true_init():
	# Returns unit's actual initiative stat
	return TrueInit

func vary_init():
	var x = randi() % 3
	match [x]:
		[0]:
			TrueInit -= InitVariance
		[1]:
			return
		[2]:
			TrueInit += InitVariance


func get_faction():
	# Returns unit's alignment
	return Faction



func give_batonpass():
	storedBatonPass = BatonPass
	BatonPass = TS.BATONPASS

func set_has_acted():
	BatonPass = TS.ACTED

func reset_acted():
	BatonPass = TS.NOTACTED
	storedBatonPass = BatonPass

func get_batonpass():
	return BatonPass



func on_turn_start():
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
	pass

func on_turn_end():
	run_passives(methodType.ON_TURN_END, null)
	SignalBus.wipeTilePaths.emit(null)
	if isPossessed:
		print("MY OG: ", OG)
	find_and_delete_passives()
	if BatonPass == TS.BATONPASS:
		BatonPass = storedBatonPass
	else:
		set_has_acted()
	
	canMove = true
	SignalBus.hasMoved.emit(self,grid.local_to_map(position)) #NOT USED YET
	SignalBus.actedUI.emit()
	print("	", Name, " has acted.")
	
	unique_turn_end()

func unique_turn_end():
	SignalBus.endTurn.emit()

func on_execute(abilityUsed):
	if AutoloadMe.turnPointer == self and Faction == fac.ALLY:
		print(self, "Ability Aftermath")
		lose_temp_ap(abilityUsed.apCost)
		set_current_ap(get_temp_ap())
		AutoloadMe.turnPointer.start = grid.local_to_map(position)


func load_ability(name):
	if name == null:
		return null
	var scene = load("res://Abilities/" + name + "/" + name + ".tscn")
	var sceneNode = scene.instantiate()
	add_child(sceneNode)
	#print("Found ", name)
	return sceneNode

func add_passive(name):
	var scene = load("res://Passives/" + name + "/" + name + ".tscn")
	var sceneNode = scene.instantiate()
	add_child(sceneNode)
	passiveList.append(sceneNode)


# PROBABLY VERY JANK. MAY NEED TO CHANGE HOW RESIZING THE ARRAY IS HANDLED
func run_passives(mType, arg):
	for i in passiveList:
		if i != null and mType == i.get_type():
			arg = i.execute(arg)
	return arg

func find_and_delete_passives():
	# checks if passive countdown == 0
	# Removes passive from passiveList and signals them to delete themselves
	for i in passiveList.size():
		if i < passiveList.size() and passiveList[i] != null and passiveList[i].turnsRemaining <= 0:
			passiveList.remove_at(i)
			SignalBus.deletePassives.emit()
		else:
			i = 0 # THIS SEEMS TO WORK BUT I FEEL LIKE IT SHOULDN'T

func spawning_in():
	set_modulate(Color(1,1,1,0))
	
	if AutoloadMe.mapID == 5:
		set_modulate(Color(0.835, 0.898, 1))
	
	get_node("AnimatedSprite2D:sprite_frames").set_sprite_frames(load("res://Scenes/Sprite Frames/" + fileName + ".tres"))
	get_node(".:Scale").set_scale(Vector2(1,1))
	get_node("AnimatedSprite2D:Scale").set_scale(Vector2(2,2))
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 2).set_trans(Tween.TRANS_SINE)
	
	SignalBus.updateFloatingHP.emit(self)
	SignalBus.remakeUnitList.emit()

func delete(unit):
	if unit == self:
		print("I AM DYING")
		SignalBus.playSFX.emit("Death")
		set_visible(false)
		set_collision_layer_value(1,false)
		set_collision_layer_value(2,false)
		AutoloadMe.globalUnitList.erase(unit)
		AutoloadMe.globalEnemyList.erase(unit)
		AutoloadMe.globalAllyList.erase(unit)
		AutoloadMe.globalTargetList.erase(unit)
		if unit.Faction == self.fac.ENEMY:
			AutoloadMe.deathCount += 1
			SignalBus.checkObjective.emit()
		SignalBus.updateGrid.emit()
		SignalBus.deleteMe.emit(self)
		await get_tree().create_timer(2).timeout
		SignalBus.HpUiFinish.emit()
		
		if AutoloadMe.turnPointer == self:
			SignalBus.endTurn.emit()
		queue_free()

func _mouse_shape_enter(shape_idx):
		myHPBar.fade(true)
		AutoloadMe.hoveredUnit = self
		SignalBus.mouseHovering.emit(true)
		SignalBus.highlightInit.emit(self, true)

func _mouse_shape_exit(shape_idx):
	if AutoloadMe.hoveredUnit == self:
		myHPBar.fade(false)
		SignalBus.mouseHovering.emit(false)
		SignalBus.highlightInit.emit(self, false)

func animated_Damaged():
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("Damaged")
	await $AnimatedSprite2D.animation_finished

func glow(unit, switch):
	if unit == self:
		if switch:
			glowTween = create_tween().set_loops().bind_node(self)
			glowTween.tween_property($AnimatedSprite2D/Glow, "modulate:a", 0.6, 0.5).set_trans(Tween.TRANS_SINE)
			glowTween.tween_property($AnimatedSprite2D/Glow, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_SINE)
		elif glowTween:
				glowTween.kill()
				glowTween = create_tween().bind_node(self)
				glowTween.tween_property($AnimatedSprite2D/Glow, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_SINE)
