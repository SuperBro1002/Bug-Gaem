extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("droneFlyIn", fly_in)
	SignalBus.connect("droneFlyOut", fly_out)
	pass # Replace with function body.

func fly_in():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(1664, 772), 1).set_trans(Tween.TRANS_ELASTIC)

func fly_out():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(2200, 772), 1).set_trans(Tween.TRANS_ELASTIC)
