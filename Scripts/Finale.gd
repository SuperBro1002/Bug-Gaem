extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("endTurn", run_credits)
	Dialogic.start("res://Dialogic Assets/Timelines/Finale.dtl")
	
func run_credits():
	#GET ALEX'S SCENES FOR HERE
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/Fountain.tscn")