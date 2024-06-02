extends event_man

var holeSprite = preload("res://Assets/Maps_Tiles/Fountain/hole.png")

func _ready():
	AutoloadMe.mapID = 1
	SignalBus.connect("checkEvents", start_round_event_check)
	SignalBus.connect("checkObjective", check_objective)

func activate_spawners():
	match AutoloadMe.roundNum:
		2:
			get_node("../TutorialMapSprite/FountainSprite").texture = holeSprite
			SignalBus.spawnGroup.emit(1)
		3:
			SignalBus.spawnGroup.emit(2)
		4:
			SignalBus.spawnGroup.emit(3)
		5:
			pass

func check_routed():
	if AutoloadMe.deathCount >= objectiveNum:
		#get_node("/root/Main_Controller").free()
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://Scenes/Cathedral 1.tscn")
