extends Control

var maxHP
var currentHP
var segList = []

func _ready():
	SignalBus.connect("updateFloatingHP", update)
	maxHP = get_parent().get_max_hp()
	make_bar()

func make_bar():
	$Temp_HP_Box/ProgressBar.set_max(maxHP)
	$Temp_HP_Box/ProgressBar.set_value(maxHP)
	
	for i in maxHP:
		var scene = load("res://Scenes/hp_seg.tscn")
		var sceneNode = scene.instantiate()
		$Temp_HP_Box/HP_Seg_Holder.add_child(sceneNode)
		segList.append(sceneNode)
	print(segList)
	#print($HP_Seg_Holder.get_children())

func update(myUnit):
	if myUnit != get_parent():
		return
	
	currentHP = get_parent().get_current_hp()
	
	$Temp_HP_Box/ProgressBar.set_value(currentHP)
	
	#print(currentHP, "/", maxHP)
	for i in segList.size():
		if i > currentHP - 1:
			segList[i].set_visible(false)
			await get_tree().create_timer(0.05).timeout
		else:
			segList[i].set_visible(true)
	
