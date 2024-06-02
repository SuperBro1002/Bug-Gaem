extends Area2D

func _ready():
	SignalBus.connect("spawnDrone", enter)

func enter():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 1.0).set_trans(Tween.TRANS_SINE)
	await tween.finished
	input_pickable = true
	

func _on_mouse_entered():
	AutoloadMe.bossdead = true
	await get_tree().create_timer(1).timeout
	SignalBus.checkObjective.emit()
