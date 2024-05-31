extends Passive_class

func _enter_tree():
	Name = "Down"
	description = "The Great Tree protects the fighter with a life-granting aura just before the moment of death. They will need to rest for the remainder of battle."
	# TO DO: POSSIBLY SWAP OUT SPRITE
	get_parent().isDown = true
	type = methodType.ON_TURN_START

func execute(_num):
	get_parent().lose_ap(1000)
