@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Ability", "Node", preload("ability.gd"), preload("star.png"))


func _exit_tree():
	remove_custom_type("Ability")
