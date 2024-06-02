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
	$HP_Text.set_text(str(maxHP))
	
	for i in maxHP:
		var scene = load("res://Scenes/hp_seg.tscn")
		var sceneNode = scene.instantiate()
		if get_parent().get_faction() == get_parent().fac.ALLY:
			#sceneNode.get_child(1).set_color(Color(0,0,0.6))
			#sceneNode.get_child(2).set_color(Color(0,0,0.82))
			sceneNode.get_child(2).set_color(Color(0, 0.518, 0.969))
			sceneNode.get_child(1).set_color(Color(0.141, 0.353, 0.843))
		$Temp_HP_Box/HP_Seg_Holder.add_child(sceneNode)
		segList.append(sceneNode)

func update(myUnit):
	if myUnit != get_parent():
		return
	
	currentHP = get_parent().get_current_hp()
	$HP_Text.set_text(str(currentHP))
	
	for i in segList.size():
		if i > currentHP - 1:
			segList[i].set_visible(false)
			await get_tree().create_timer(0.05).timeout
		else:
			segList[i].set_visible(true)
			await get_tree().create_timer(0.05).timeout
	
	SignalBus.HpUiFinish.emit()

func fade(isHovering):
	var tween = create_tween()
	if isHovering:
		tween.tween_property(self, "modulate:a", 1, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)
	else:
		tween.tween_property(self, "modulate:a", 0.5, 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)
