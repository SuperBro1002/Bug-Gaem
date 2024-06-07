extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("spawnDrone", set_drone_text)

func set_drone_text():
	get_child(0).set_text("Use Zephyr to deal the final blow!")
	get_child(1).set_visible(false)
	get_child(2).set_visible(false)
	get_child(3).set_visible(false)
