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
		if unit.Faction == unit.fac.OBSTACLE:
			var portraitRes = load("res://Assets/Sprites/Obstacles/" + unit.fileName + ".png")
			get_node("../SecondaryInfoBox/PortraitBox/PortraitSprite").texture = portraitRes
			$Sprite2D.set_scale(Vector2(1,0.6))
			$Name.set_text(unit.Name)
			$HPValue.set_text(str(unit.get_current_hp(), " / ", unit.get_max_hp()))
			$Abilities.set_visible(false)
			$APValue.set_visible(false)
			$APLabel.set_visible(false)
			$GridContainer/MarginContainer.set_visible(false)
			$GridContainer/MarginContainer2.set_visible(false)
			$GridContainer/MarginContainer3.set_visible(false)
			$GridContainer/Description1.set_visible(false)
			$GridContainer/Description2.set_visible(false)
			$GridContainer/Description3.set_visible(false)
			
		else:
			$Sprite2D.set_scale(Vector2(1.263,1.263))
			$Abilities.set_visible(true)
			$APLabel.set_visible(true)
			$APValue.set_visible(true)
			$GridContainer/MarginContainer.set_visible(true)
			$GridContainer/MarginContainer2.set_visible(true)
			$GridContainer/MarginContainer3.set_visible(true)
			$GridContainer/Description1.set_visible(true)
			$GridContainer/Description2.set_visible(true)
			$GridContainer/Description3.set_visible(true)
			
			var portraitRes = load("res://Assets/Sprites/" + unit.fileName + "/" + unit.fileName + "_Base_Still.png")
			if AutoloadMe.mapID == 5 and unit.fileName == "Thor":
				portraitRes = load("res://Assets/Sprites/Thor/Corrupted_Thor_Base_Still.png")
			get_node("../SecondaryInfoBox/PortraitBox/PortraitSprite").texture = portraitRes
			
			$Name.set_text(unit.Name)
			$HPValue.set_text(str(unit.get_current_hp(), " / ", unit.get_max_hp()))
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
