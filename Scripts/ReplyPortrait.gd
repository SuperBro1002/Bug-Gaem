extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("changeReplyPortrait", change)
	return
	
func change(filename):
	texture = "res://Assets/Portraits/" + AutoloadMe.turnPointer.Name + "/" + filename + ".png"
	return
