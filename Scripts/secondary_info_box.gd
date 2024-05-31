extends ColorRect

var unit = null

func _ready():
	SignalBus.connect("mouseHovering", fill_me)
	SignalBus.connect("updateUI", fill_me)
	SignalBus.connect("deleteMe",handleDead)

func fill_me(_isHovering):
	unit = AutoloadMe.hoveredUnit
	if unit == null:
		return
	
	var portraitRes = load("res://Assets/Sprites/" + unit.fileName + "/" + unit.fileName + "_Base_Still.png")
	get_node("../SecondaryInfoBox/PortraitBox/PortraitSprite").texture = portraitRes
	
	$Name.set_text(unit.Name)
	$HPValue.set_text(str(unit.get_current_hp(), " / ", unit.get_max_hp()))
	
	if unit.Faction == unit.fac.OBSTACLE:
		return
	
	if unit.Faction == unit.fac.ENEMY:
		$APValue.set_text(str(unit.get_current_ap(), " / ", unit.get_max_ap()))
	elif unit.Faction == unit.fac.ALLY:
		$APValue.set_text(str(unit.get_current_ap(), " / ", unit.get_max_ap()))
	
	
	$GridContainer/MarginContainer/Ability1.set_text(unit.ability1.Name)
	$GridContainer/Description1.set_text(unit.ability1.description)
	
	if unit.ability2 != null:
		$GridContainer/MarginContainer2/Ability2.set_text(unit.ability2.Name)
		$GridContainer/Description2.set_text(unit.ability2.description)
	else:
		$GridContainer/MarginContainer2/Ability2.set_text("")
		$GridContainer/Description2.set_text("")
	
	if unit.ability3 != null:
		$GridContainer/MarginContainer3/Ability3.set_text(unit.ability3.Name)
		$GridContainer/Description3.set_text(unit.ability3.description)
	else:
		$GridContainer/MarginContainer3/Ability3.set_text("")
		$GridContainer/Description3.set_text("")

func handleDead(DyingUnit):
	if DyingUnit == unit:
		SignalBus.mouseHovering.emit(false)
