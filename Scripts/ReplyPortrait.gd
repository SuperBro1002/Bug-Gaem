extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("changeReplyPortrait", change)
	SignalBus.connect("showReplyPortrait", show_reply_portrait)
	SignalBus.connect("hideReplyPortrait", hide_reply_portrait)
	return
	
func change(character, filename):
	texture = load("res://Assets/Portraits/" + character + "/" + filename + ".png")
	return

func show_reply_portrait():
	self.visible = true
	return

func hide_reply_portrait():
	self.visible = false
	return
