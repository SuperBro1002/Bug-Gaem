extends Area2D

var areaType = "range_box"
var myUnit
var ability
var hasUnit = false

func _enter_tree():
	set_modulate(Color(1,0,0,0.5))
	myUnit = get_parent().get_parent().get_parent()
	ability = get_parent().get_parent()

func _on_area_entered(area):
	if area.areaType == "spawner" or area.areaType == "range_box" or area.areaType == "selection_box":
		return
	if AutoloadMe.turnPointer == myUnit and area != myUnit and ability.type_matches(area.get_faction()):
		if area.areaType == "unit" or area.areaType == "obstacle":
			hasUnit = true
			print("HAS A UNIT")


func _on_area_exited(area):
	hasUnit = false


func _on_mouse_entered():
	print("MOUSE ENTERED")
	#position = myUnit.grid.map_to_local(Vector2i(7,8))
	if AutoloadMe.turnPointer == myUnit and hasUnit:
		set_modulate(Color(1,0,0,1))
		#set_modulate(Color(0.4,1,0,1))
		print("CHANGING")


func _on_mouse_exited():
	set_modulate(Color(1,0,0,0.5))
