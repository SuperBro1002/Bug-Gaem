@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Passive", "Node", preload("passive.gd"), preload("arrows.png"))


func _exit_tree():
	remove_custom_type("Passive")
