extends Control

func _ready():
	SignalBus.connect("currentUnit", set_ui_portrait)

func set_ui_portrait(unit):
	if unit.get_faction() == unit.fac.ALLY:
		var portraitRes = load("res://Assets/Sprites/Allies/" + unit.Name+"/"+unit.Name+"_Base_Still.png")
		get_node("../UI/InfoBox/PortraitBox/Sprite2D").texture = portraitRes
	


func _on_sprite_2d_texture_changed():
	print("CHANGED")
