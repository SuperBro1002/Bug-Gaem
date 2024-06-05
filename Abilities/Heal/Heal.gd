extends Ability_class

var healNum = 3

func _enter_tree():
	targetType = [get_parent().fac.ALLY]
	Name = "Healing Light"
	fileName = "Heal"
	description = "Heals an ally within 3 spaces for 3 health. 6 AP"

func execute():
	# for every target in target units[]
		# For each target in target_tiles[]
	print("EXECUTED ", AutoloadMe.currentAbility)
	print(targetUnits)
	
	face_target()
	get_parent().get_node("AnimatedSprite2D").stop()
	get_parent().get_node("AnimatedSprite2D").play("Cast1")
	await get_tree().create_timer(1).timeout
	$VFX.position = targetUnits[0].position
	$VFX.position.x -= 65
	$VFX.set_visible(true)
	SignalBus.playSFX.emit("Heal")
	$VFX.play("Effect")
	await get_tree().create_timer(0.3).timeout
	$VFX.set_visible(false)
	
	for i in targetUnits.size():
		targetUnits[i].gain_health(healNum)
	
	healNum = 3
	
	post_execute()
