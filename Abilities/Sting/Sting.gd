extends Ability_class


func _enter_tree():
	targetType = [get_parent().fac.ENEMY, get_parent().fac.OBSTACLE]
	Name = "Sting"
	fileName = "Sting"
	description = "Deals 4 damage to an adjacent target. User takes 1 recoil damage. 4 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED")
	print(targetUnits)
	
	face_target()
	get_parent().get_node("AnimatedSprite2D").stop()
	get_parent().get_node("AnimatedSprite2D").play("Attack1")
	$VFX.position = targetUnits[0].position
	$VFX.position.x -= 50
	$VFX.set_visible(true)
	SignalBus.playSFX.emit("Sting")
	$VFX.play("Effect")
	await get_tree().create_timer(0.7).timeout
	
	for i in targetUnits.size():
		targetUnits[i].lose_health(4)
		await get_tree().create_timer(0.3).timeout
		get_parent().incoming_dmg_type = "pierce"
		get_parent().lose_health(1)
	
	$VFX.set_visible(false)
	post_execute()
