extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.playMusic.emit("Bioluminescence")

func _on_start_button_pressed():
	SignalBus.playSFX.emit("Queue")
	await get_tree().create_timer(1)
	get_tree().change_scene_to_file("res://Scenes/Fountain.tscn")


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/options.tscn")

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")


func _on_quit_button_pressed():
	SignalBus.playSFX.emit("Dequeue")
	get_tree().quit()
