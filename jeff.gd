extends Unit_class

var speed = 0
var screenSize

var type = fac.NONE

func _ready():
	screenSize = get_viewport_rect().size
	init_stats(0,0,0,0,0,-999,type,0)

func onTurnStart():
	print("JEFF TURN START")
	on_turn_end()

func on_turn_end():
	print("JEFF PASSES TURN")
	BatonPass = -1
	SignalBus.endRound.emit()
