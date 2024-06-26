extends Unit_class

var type = fac.OBSTACLE

func _ready():
	areaType = "obstacle"
	grid = find_parent("Grid")

func _enter_tree():
	pass

func lose_health(dmgVal):
	dmgVal *= AutoloadMe.currentAbility.dmgMod
	CurrentHP = CurrentHP - dmgVal
	if CurrentHP < 0:
		CurrentHP = 0
	if CurrentHP == 0:
		delete(self)
	incoming_dmg_type = null

func delete(unit):
	if unit == self:
		print("I AM DYING")

		AutoloadMe.globalTargetList.erase(unit)
		SignalBus.updateGrid.emit()
		SignalBus.deleteMe.emit(self)
		queue_free()

func add_passive(_name):
	pass

func on_turn_start():
	pass

func on_turn_end():
	pass

func _mouse_shape_enter(_shape_idx):
	AutoloadMe.hoveredUnit = self
	SignalBus.mouseHovering.emit(true)

func _mouse_shape_exit(_shape_idx):
	if AutoloadMe.hoveredUnit == self:
		SignalBus.mouseHovering.emit(false)
		AutoloadMe.hoveredUnit = null
