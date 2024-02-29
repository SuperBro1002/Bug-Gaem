extends Unit_class

var speed = 0
var screenSize

var type = fac.NONE

func _ready():
	screenSize = get_viewport_rect().size
	init_stats(0,0,0,0,0,-999,type,TS.NOTACTED)

func onTurnStart():
	print("	jeff turn start")
	on_turn_end()

func on_turn_end():
	print("	jeff passes turn")
	set_has_acted()
	SignalBus.endRound.emit()
