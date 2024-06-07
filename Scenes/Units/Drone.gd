extends Area2D

func _ready():
	SignalBus.connect("spawnDrone", enter)

func enter():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 1.0).set_trans(Tween.TRANS_SINE)
	await tween.finished
	var node = Dialogic.start("res://Dialogic Assets/Timelines/Drone.dtl")
	node.register_character(load("res://Dialogic Assets/Characters/Drone.dch"), get_child(1))
	
	await get_tree().create_timer(4).timeout
	input_pickable = true


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.get_button_index() == 1:
		SignalBus.playSFX.emit("BossDeath2")
		AutoloadMe.bossdead = true
		print("GAME IS DONE")
		SignalBus.checkObjective.emit()
