extends Ability_class

var sceneNode

func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "X-Slash"
	fileName = "X-Slash"
	description = "Deals 3 damage to an adjacent enemy and grants baton pass. If the target dies from this attack, they become possessed. They then perish after taking one turn. 3 AP"

func post_execute():
	dmgMod = 1
	targetUnits.clear()
	get_parent().grid.update_grid_collision()
	SignalBus.abilityExecuted.emit(self)
	SignalBus.updateUI.emit(get_parent())
	AutoloadMe.isExecuting = false
	SignalBus.changeControls.emit()
	if get_parent().Faction == get_parent().fac.ALLY:
		SignalBus.changeButtonState.emit()
	elif get_parent().Faction == get_parent().fac.ENEMY:
		dequeue(1,false)
	await get_tree().create_timer(1).timeout
	AutoloadMe.passingUnit = get_parent()
	get_parent().on_turn_end()

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	face_target()
	SignalBus.playSFX.emit("X-slash")
	get_parent().get_node("AnimatedSprite2D").stop()
	get_parent().get_node("AnimatedSprite2D").play("Attack1")
	
	$VFX.position = targetUnits[0].position
	
	if target_is_right():
		$VFX.set_flip_h(false)
		$VFX.position.x -= 60
	else:
		$VFX.set_flip_h(true)
		$VFX.position.x += 60
	
	$VFX.set_visible(true)
	$VFX.play("Effect")
	await get_tree().create_timer(0.7).timeout
	
	for i in targetUnits.size():
		if targetUnits[i].get_current_hp() - 3 <= 0 and targetUnits[i].Faction != get_parent().fac.OBSTACLE and targetUnits[i].Controllable == true:
			var scene = load("res://Scenes/ally.tscn")
			sceneNode = scene.instantiate()
			get_node("../..").add_child(sceneNode)
			#sceneNode.isPossessed = true
			sceneNode.clone(targetUnits[i])
			
			SignalBus.addToUnitList.emit(sceneNode)
			#SignalBus.remakeUnitList.emit()
			#await get_tree().create_timer(1).timeout
		else:
			targetUnits[i].give_batonpass()
		targetUnits[i].lose_health(3)
	
	$VFX.set_visible(false)
	post_execute()
