extends Node

# This is an autoloaded script that connects Dialogic and the PortraitSprite nodes via Signals
# Dialogic can only handle one signal in line, so I figured this would be a little easier to track visually
# This simply runs two signals, saying which portrait should be displayed
# IMPORTANT: The format should always be the same: "nameOfCharacter_mood"
# This will be the actual filename of the desired portrait

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func change_main_portrait(filename):
	SignalBus.changeMainPortrait.emit(filename)
	return

func change_reply_portrait(filename):
	SignalBus.changeReplyPortrait.emit(filename)
	return
