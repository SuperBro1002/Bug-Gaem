extends Unit_class

var speed = 225
var screenSize

var type

func _ready():
	screenSize = get_viewport_rect().size
	type = get_parent().faction.ENEMY
	init_stats(55,66,77,88,99,111,type)

func test_call():
	print("GOODBYE WORLD")


func ability1():
	# Trigger first skill when in range
	pass

func ability2():
	# Trigger second skill when in range
	pass