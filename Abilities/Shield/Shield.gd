extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ALLY]
	Name = "Shining Barrier"
	fileName = "Shield"
	description = "Grants an adjacent ally a barrier that nullifies damage from 1 attack. (Doesn't stack) Also grants baton pass. 5 AP"

func post_execute():
	dmgMod = 1
	targetUnits.clear()
	get_parent().grid.update_grid_collision()
	SignalBus.abilityExecuted.emit(self)
	SignalBus.updateUI.emit(get_parent())
	AutoloadMe.isExecuting = false
	SignalBus.changeControls.emit()
	AutoloadMe.set_process_unhandled_input(true)
	if get_parent().Faction == get_parent().fac.ALLY:
		SignalBus.changeButtonState.emit()
	elif get_parent().Faction == get_parent().fac.ENEMY:
		dequeue(1,false)
	#await get_tree().create_timer(1).timeout
	AutoloadMe.passingUnit = get_parent()
	# get_parent().on_turn_end()

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	var hasArmor = false
	print("EXECUTED")
	print(targetUnits)
	
	face_target()
	get_parent().get_node("AnimatedSprite2D").stop()
	get_parent().get_node("AnimatedSprite2D").play("Cast3")
	await get_tree().create_timer(0.8).timeout
	$VFX.position = targetUnits[0].position
	$VFX.position.x -= 65
	SignalBus.playSFX.emit("Shield")
	$VFX.set_visible(true)
	$VFX.play("Effect")
	await get_tree().create_timer(0.3).timeout
	$VFX.set_visible(false)
	
	for i in targetUnits.size():
		for j in targetUnits[i].passiveList.size():
			if targetUnits[i].passiveList[j].Name == "Armor":
				hasArmor = true
		
		targetUnits[i].give_batonpass()
		if !hasArmor:
			targetUnits[i].add_passive("Armor")
	
	post_execute()
