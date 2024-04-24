extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("changeMainPortrait", change)
	return
	
func change(filename):
	texture = filename
	return
