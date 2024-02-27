extends Unit_class

var speed = 225
var screenSize

var type = fac.ENEMY

func _ready():
	screenSize = get_viewport_rect().size
	init_stats(55,66,77,88,99,111,type,0)

func onTurnStart():
	#reset_ap()
	print("ENEMY TURN START")
	on_turn_end()

func on_turn_end():
	print("ENEMY PASSES TURN")
	BatonPass = -1
	SignalBus.endTurn.emit()

func ability1():
	# Trigger first skill when in range
	pass

func ability2():
	# Trigger second skill when in range
	pass
