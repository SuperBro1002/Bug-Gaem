extends Area2D

func _ready():
	SignalBus.connect("spawnDrone", enter)

func enter():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 1.0).set_trans(Tween.TRANS_SINE)
	await tween.finished
	input_pickable = true
	var node = Dialogic.start("res://Dialogic Assets/Timelines/Drone.dtl")
	node.register_character(load("res://Dialogic Assets/Characters/Drone.dch"), get_child(1))
	
	

func _on_mouse_entered():
	#if Input.is_action_just_pressed("left_click"):
	SignalBus.playSFX.emit("BossDeath2")
	AutoloadMe.bossdead = true
	await get_tree().create_timer(3).timeout
	SignalBus.checkObjective.emit()
