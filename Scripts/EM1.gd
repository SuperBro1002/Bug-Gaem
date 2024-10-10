extends event_man

var holeSprite = preload("res://Assets/Maps_Tiles/Fountain/hole.png")
var nextScene = "res://Scenes/Cathedral 1.tscn"

func _ready():
	AutoloadMe.mapID = 1
	SignalBus.connect("checkEvents", start_round_event_check)
	SignalBus.connect("checkObjective", check_objective)

func activate_spawners():
	match AutoloadMe.roundNum:
		2:
			if Dialogic.VAR.TutorialDrillSeen == true: return
			SignalBus.playSFX.emit("BossDeath2")
			get_node("../TutorialMapSprite/FountainSprite").texture = holeSprite
			SignalBus.spawnGroup.emit(1)
			Dialogic.VAR.CutsceneUp = true
			Dialogic.start("res://Dialogic Assets/Timelines/Tutorial Drill.dtl")
		3:
			SignalBus.spawnGroup.emit(2)
		4:
			SignalBus.spawnGroup.emit(3)
		5:
			pass

func check_routed():
	if AutoloadMe.deathCount >= objectiveNum:
		AutoloadMe.set_process_unhandled_input(false)
		await get_tree().create_timer(1).timeout
		#Update and save level variable
		AutoloadMe.level = 2
		AutoloadMe.save()
		get_tree().change_scene_to_file(nextScene)
