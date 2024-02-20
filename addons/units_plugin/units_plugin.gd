@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Unit", " Area2D", preload("unit.gd"), preload("robin.png"))


func _exit_tree():
	remove_custom_type("Unit")
