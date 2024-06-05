extends AudioStreamPlayer

# PRELOAD MUSIC HERE

func _ready():
	SignalBus.connect("playMusic", playMusic)
	set_bus("Music")

func playMusic(fileName):
	if is_playing():
		play()
	else:
		play()
