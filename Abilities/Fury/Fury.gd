extends Ability_class

var direction
var localDirection
var pathArray

func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "Fury Skewer"
	fileName = "Fury"
	description = "Thor'axe dashes 9 spaces forward, dealing 6 damage to foes in his path. 9 AP"

func enemy_execute(initTarget):
	print("INTIATING FURY")
	#targetUnits.append(initTarget)
	
	$Area2D/SelectionBox.set_visible(true)
	SignalBus.playSFX.emit("powerflutter")
	if initTarget.position.x > get_parent().position.x:
		direction = Vector2.RIGHT
		#print("Right")
	elif initTarget.position.x < get_parent().position.x:
		direction = Vector2.LEFT
		#print("Left")
	elif initTarget.position.y < get_parent().position.y:
		direction = Vector2.UP
		#print("Above")
	elif initTarget.position.y > get_parent().position.y:
		direction = Vector2.DOWN
		#print("Below")
	localDirection = direction * 64
	print("HERERERERERE ", direction)
	$Area2D.position = get_parent().position
	get_parent().end = get_parent().grid.local_to_map(localDirection * 9)
	
	pathArray = AutoloadMe.movementGrid.get_point_path(get_parent().start, get_parent().end)
	await get_tree().create_timer(0.7).timeout
	await execute()

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	await get_tree().create_timer(0.1).timeout
	
	face_target()
	get_parent().get_node("AnimatedSprite2D").stop()
	get_parent().get_node("AnimatedSprite2D").play("Attack1")
	await get_tree().create_timer(0.7).timeout
	
	for i in 8:
		if AutoloadMe.movementGrid.is_point_solid(Vector2i(get_parent().grid.local_to_map(get_parent().position) + Vector2i(direction))):
			break
		else:
			var tween = create_tween()
			tween.tween_property(get_parent(), "position", get_parent().position + localDirection, 1.0 / get_parent().animationSpeed).set_trans(Tween.TRANS_SINE)
			await tween.finished
			$Area2D.position = get_parent().position
	
	var tween2 = create_tween()
	tween2.tween_property(get_parent(), "position", get_parent().grid.flood_fill_first(get_parent().grid.local_to_map(get_parent().position)), 1.0 / get_parent().animationSpeed).set_trans(Tween.TRANS_SINE)
	await tween2.finished
	
	print("After Loop")
	for i in targetUnits.size():
		print(targetUnits.size())
		print(targetUnits, " ", i)
		if targetUnits == null:
			return
		targetUnits[i].lose_health(6)
	post_execute()
