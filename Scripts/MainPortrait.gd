extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("changeMainPortrait", change)
	SignalBus.connect("hideMainPortrait", hide_self)
	return
	
func change(filename):
	texture = load("res://Assets/Portraits/" + AutoloadMe.turnPointer.Name + "/" + filename + ".png")
	set_visible(true)
	return
	
func hide_self():
	set_visible(false)
