@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Event", "Node", preload("event_manager.gd"), preload("mark.png"))


func _exit_tree():
	remove_custom_type("Event")

