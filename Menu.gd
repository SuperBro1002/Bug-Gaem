extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.playMusic.emit("Bioluminescence")
	# Load AutoloadMe.gd into variable (tbh I'm unsure if this is necessary)
	var AutoloadMe = get_node("/root/AutoloadMe")

func _on_start_button_pressed():
	SignalBus.playSFX.emit("Queue")
	await get_tree().create_timer(1)
	# Load current level based on save data
	AutoloadMe.load_data()
	if AutoloadMe.level==1:
		get_tree().change_scene_to_file("res://Scenes/Fountain.tscn")
	elif AutoloadMe.level==2:
		get_tree().change_scene_to_file("res://Scenes/Cathedral 1.tscn")
	elif AutoloadMe.level==3:
		get_tree().change_scene_to_file("res://Scenes/garden.tscn")
	elif AutoloadMe.level==4:
		get_tree().change_scene_to_file("res://Scenes/Cathedral 2.tscn")
	elif AutoloadMe.level==5:
		get_tree().change_scene_to_file("res://Scenes/Fountain 2.tscn")
	else:
		AutoloadMe.level = 1
		AutoloadMe.save()
		get_tree().change_scene_to_file("res://Scenes/Fountain.tscn")


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/options.tscn")

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")


func _on_quit_button_pressed():
	SignalBus.playSFX.emit("Dequeue")
	get_tree().quit()
