extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ALLY]
	Name = "Shield"
	fileName = "Shield"
	description = "Grants an adjacent ally a shield that nullifies damage from 1 attack. Also grants baton pass. 4 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	face_target()
	get_parent().get_node("AnimatedSprite2D").stop()
	get_parent().get_node("AnimatedSprite2D").play("Cast3")
	await get_tree().create_timer(0.8).timeout
	$VFX.position = targetUnits[0].position
	$VFX.position.x -= 65
	$VFX.set_visible(true)
	$VFX.play("Effect")
	await get_tree().create_timer(0.3).timeout
	$VFX.set_visible(false)
	
	for i in targetUnits.size():
		targetUnits[i].add_passive("Armor")
		targetUnits[i].give_batonpass()
	
	post_execute()
