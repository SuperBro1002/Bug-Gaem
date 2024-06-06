extends Node

# PRELOAD MUSIC HERE

@onready var animation_player = $AnimationPlayer
@onready var previous_track = $PreviousTrack
@onready var current_track = $CurrentTrack
#@onready var main_loop = $MainLoop
var time = 0
var loop_point

func _ready():
	SignalBus.connect("playMusic", play_music)
	SignalBus.connect("quickSwap", quick_swap)
	SignalBus.connect("silenceMusic", silence_music)
	#main_loop.connect("finished", _on_loop_music)
	previous_track.set_bus("Music")
	current_track.set_bus("Music")
	#main_loop.set_bus("Music")

func silence_music():
	animation_player.play("Fade Out")

#func _process(delta):
	#print(time, " / ", loop_point)
	#if current_track.is_playing():
		#if current_track.get_playback_position() >= loop_point:
			#main_loop.set_stream(current_track.stream)
			#time = current_track.get_playback_position()
			#main_loop.play(time)
			#current_track.playing = false
			#print("69 I HAVE LOOPED THE SONG")
			#return
	#if main_loop.is_playing():
		#if main_loop.get_playback_position() < loop_point:
			#main_loop.play(loop_point)
			#return

#func _on_loop_music():
	#main_loop.play(loop_point)

#func set_loop_point(fileName):
	#match fileName:
		#"Bioluminescence": loop_point = 18
		#"Lunar Eclipse": loop_point = 18
		#"Lifeline-Phase 1": loop_point = 128/11
		#"Lifeline-Phase 2": loop_point = 128/11
		#"Lifeline-Phase 3": loop_point = 128/11
		#"Lifeline-Phase 4": loop_point = 128/11
		#"Lifeline-Phase 5": loop_point = 128/11
		#"Metamorphosis": loop_point = 960/83
		#"Drill Sergeant": loop_point = 6
func quick_swap(fileName):
	if current_track.is_playing():
		time = current_track.get_playback_position()
		previous_track.set_stream(current_track.get_stream())
		current_track.set_stream(load(str("res://Assets/Audio/Music/", fileName, ".mp3")))
		current_track.play(time)
		previous_track.play(time)
		animation_player.play("Fade In Current Track Quick")

func play_music(fileName):
	#set_loop_point(fileName)
	if current_track.is_playing():
		time = current_track.get_playback_position()
		previous_track.set_stream(current_track.get_stream())
		current_track.set_stream(load(str("res://Assets/Audio/Music/", fileName, ".mp3")))
		current_track.play(0)
		previous_track.play(time)
		animation_player.play("Fade In Current Track")
		return
	else:
		print("I SHOULD BE HEARING SOMETHING???")
		current_track.set_stream(load(str("res://Assets/Audio/Music/", fileName, ".mp3")))
		current_track.play(0)
		animation_player.play("Fade In")
		return
	#if main_loop.is_playing():
		#time = main_loop.get_playback_position()
		#previous_track.set_stream(main_loop.stream)
		#main_loop.playing = false
	return
