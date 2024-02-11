extends Unit_class

var speed = 225
var screenSize

enum faction {
	ALLY,
	ENEMY
}

func _ready():
	screenSize = get_viewport_rect().size
	init_stats(55,66,77,88,99,111,faction.ENEMY)

func test_call():
	print("GOODBYE WORLD")


func ability1():
	# Trigger first skill when in range
	pass

func ability2():
	# Trigger second skill when in range
	pass
