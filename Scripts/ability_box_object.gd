extends ColorRect

func _ready():
	pass

func set_my_text(ability):
	print("WORKING")
	$MarginContainer/Ability.set_text(ability.Name)
	$MarginContainer/Description.set_text(ability.description)
