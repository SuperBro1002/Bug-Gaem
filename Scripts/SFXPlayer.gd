extends AudioStreamPlayer

func _ready():
	SignalBus.connect("playSFX", playSFX)
	set_bus("SFX")

func playSFX(fileName):
	set_stream(load(str("res://Assets/Audio/SFX/", fileName, ".wav")))
	play()
