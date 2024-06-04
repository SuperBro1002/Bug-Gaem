extends Node

var main_portrait
var reply_portrait
var reply_portrait_visible

func _ready():
	pass
	
func change_main_portrait(filename):
	SignalBus.changeMainPortrait.emit(filename)
	main_portrait = "res://Assets/Portraits/" + AutoloadMe.turnPointer.Name + "/" + filename + ".png"
	return

func change_reply_portrait(character, filename):
	SignalBus.changeReplyPortrait.emit(character, filename)
	reply_portrait = "res://Assets/Portraits/" + character + "/" + filename + ".png"
	return

func show_reply_portrait(character, filename):
	change_reply_portrait(character, filename)
	SignalBus.showReplyPortrait.emit()
	reply_portrait_visible = true
	return

func hide_reply_portrait():
	SignalBus.hideReplyPortrait.emit()
	reply_portrait_visible = false
	return
