extends Control

var animationSpeed = 4
var maxHP
var currentHP
var segList = []

func _ready():
	SignalBus.connect("updateFloatingHP", update)
	maxHP = get_parent().get_max_hp()
	make_bar()

func make_bar():
	get_parent().myHPBar = self
	$Temp_HP_Box/ProgressBar.set_max(maxHP)
	$Temp_HP_Box/ProgressBar.set_value(maxHP)
	
	for i in maxHP:
		var scene = load("res://Scenes/hp_seg.tscn")
		var sceneNode = scene.instantiate()
		$Temp_HP_Box/HP_Seg_Holder.add_child(sceneNode)
		segList.append(sceneNode)

func update(myUnit):
	if myUnit != get_parent():
		return
	
	currentHP = get_parent().get_current_hp()
	
	$Temp_HP_Box/ProgressBar.set_value(currentHP)
	
	for i in segList.size():
		if i > currentHP - 1:
			segList[i].set_visible(false)
			await get_tree().create_timer(0.05).timeout
		else:
			segList[i].set_visible(true)
			await get_tree().create_timer(0.05).timeout
		
	if currentHP == 0:
		SignalBus.deleteMe.emit(get_parent())

func fade(isHovering):
	var tween = create_tween()
	if isHovering:
		tween.tween_property(self, "modulate:a", 1, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)
	else:
		tween.tween_property(self, "modulate:a", 0.5, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)
