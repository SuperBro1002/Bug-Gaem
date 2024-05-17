extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "Sacrifice Sting"
	fileName = " Sacrifice_Sting"
	description = "Lose all HP and deal 4 damage to all enemies surrounding you. (All HP)"
	SignalBus.connect("ability",hijack)

func hijack(num, state):
	if num == 3 and state == true and AutoloadMe.turnPointer == get_parent():
		queue()

func queue():
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
	
	for i in targetUnits.size():
		targetUnits[i].lose_health(4)
		get_parent().lose_health(get_parent().get_max_hp())
	
	post_execute()
