extends Unit_class

var speed = 225
var screenSize

var type = fac.ENEMY

func _ready():
	screenSize = get_viewport_rect().size
	#init_stats(55,66,77,88,99,111,type,TS.NOTACTED)

func unique_turn_start():
	#reset_ap()
	print("	enemy turn start")
	on_turn_end()

func ability1():
	# Trigger first skill when in range
	pass

func ability2():
	# Trigger second skill when in range
	pass
