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
	$APValue.set_text(str(unit.get_current_ap(), " / ", unit.get_max_ap()))
	
	$GridContainer/MarginContainer/Ability1.set_text(unit.SetAbility1)
	$GridContainer/Description1.set_text(unit.ability1.description)
	
	$GridContainer/MarginContainer2/Ability2.set_text(unit.SetAbility2)
	$GridContainer/Description2.set_text(unit.ability2.description)
	
	$GridContainer/MarginContainer3/Ability3.set_text(unit.SetAbility3)
	$GridContainer/Description3.set_text(unit.ability3.description)

func handleDead(DyingUnit):
	if DyingUnit == unit:
		SignalBus.mouseHovering.emit(false)
