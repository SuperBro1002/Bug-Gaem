extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "Sacrifice Sting"
	fileName = " Sacrifice_Sting"
	description = "Deals 4 damage to all enemies surrounding you. Your HP is reduced to 1. (HP)"
	SignalBus.connect("ability",hijack)

func hijack(num, state):
	if num == 3 and state == true and AutoloadMe.turnPointer == get_parent():
		queue()

func queue():
	AutoloadMe.currentAbility = self
	if get_parent().get_temp_ap() - apCost >= 0:
		clickedPos = get_parent().grid.local_to_map(get_parent().position)
		
		clickedDistance = abilityGrid.get_point_path(get_parent().abilityStartPoint,clickedPos)
		print("I start: ", get_parent().abilityStartPoint)
		
		$Area2D.position = get_parent().grid.map_to_local(clickedPos)
		$Area2D/SelectionBox.set_visible(true)
		
		await get_tree().create_timer(0.1).timeout
		
		if !targetUnits.is_empty():
			SignalBus.activelyQueueing.emit(true)
		else:
			SignalBus.activelyQueueing.emit(false)
		
		print(targetUnits)

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	#face_target()
	get_parent().get_node("AnimatedSprite2D").stop()
	get_parent().get_node("AnimatedSprite2D").play("Cast1")
	SignalBus.playSFX.emit("SacrificialSting")
	$VFX.set_visible(true)
	$VFX.position = get_parent().position
	$VFX.play("Effect")
	await get_tree().create_timer(1).timeout
	
	for i in targetUnits.size():
		targetUnits[i].lose_health(4)
	await get_tree().create_timer(0.5).timeout
	get_parent().incoming_dmg_type = "pierce"
	# I don't think Triss should be ordered to kill herself so this now spares her with 1 hp
	if get_parent().get_current_hp() != 1:
		get_parent().lose_health(get_parent().get_current_hp()-1)
	
	$VFX.set_visible(false)
	post_execute()
