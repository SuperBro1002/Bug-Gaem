extends Control

func _ready():
	SignalBus.connect("deleteInitObject", remove_me)

func assign_sprite(fileName):
	var spritePath = load("res://Assets/HUD/Init_Sprites/" + fileName + "_Base_Still.png")
	get_node("Sprite2D").texture = spritePath
	#print("UIIIIIIIIIIIIIII ", get_node("Sprite2D"))

func remove_me():
	queue_free()
