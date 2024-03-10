extends Unit_class

var speed = 225
var screenSize

var ability1 = load_ability(SetAbility1)
var ability2 = load_ability(SetAbility2)
var ability3 = load_ability(SetAbility3)

var type = fac.ENEMY

func _ready():
	screenSize = get_viewport_rect().size
	#init_stats(55,66,77,88,99,111,type,TS.NOTACTED)

func unique_turn_start():
	#reset_ap()
	print("	enemy turn start")
	on_turn_end()
