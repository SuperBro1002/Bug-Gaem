extends ColorRect

func _ready():
	pass

func set_my_text(passive):
	if passive.Name == null: return
	$VBoxContainer/PassiveTitle.set_text(passive.Name)
	$VBoxContainer/Description.set_text(passive.description)