extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ALLY, get_parent().fac.OBSTACLE]
	Name = "Chainsaw Boomerang"
	fileName = "Chainsaw"
	description = "Deals 2 damage to targets in a 4-tile line in front of the user. 6 AP"

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
	
	for i in targetUnits.size():
		#print(targetUnits.size())
		#print(targetUnits, " ", i)
		if targetUnits == null:
			return
		await targetUnits[i].lose_health(2)
	post_execute()
