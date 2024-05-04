extends Node

var currentUnitTurn
@onready var unitMan = $UnitManager

func _ready():
	make_unit_list()
	SignalBus.connect("endTurn", next_turn)
	SignalBus.connect("endRound", next_round)
	SignalBus.connect("remakeUnitList", make_unit_list)
	SignalBus.connect("addToUnitList", add_unit_list)

# Probably main function
func next_turn():
	for i in (AutoloadMe.globalUnitList.size()):
		if AutoloadMe.globalUnitList[i].get_batonpass() == AutoloadMe.globalUnitList[i].TS.BATONPASS:
			currentUnitTurn = AutoloadMe.globalUnitList[i]
			SignalBus.currentUnit.emit(currentUnitTurn)
			currentUnitTurn.on_turn_start()
			return
	for i in (AutoloadMe.globalUnitList.size()):
		if AutoloadMe.globalUnitList[i].get_batonpass() == AutoloadMe.globalUnitList[i].TS.NOTACTED:
			currentUnitTurn = AutoloadMe.globalUnitList[i]
			SignalBus.currentUnit.emit(currentUnitTurn)
			currentUnitTurn.on_turn_start()
			return

func next_round():
	AutoloadMe.roundNum += 1
	SignalBus.checkEvents.emit()
	for j in (AutoloadMe.globalUnitList.size()):
		AutoloadMe.globalUnitList[j].reset_acted()
		AutoloadMe.globalUnitList[j].reset_ap()
	currentUnitTurn = AutoloadMe.globalUnitList[0]
	print("ROUND END. RESETTING: ", currentUnitTurn)
	SignalBus.currentUnit.emit(currentUnitTurn)
	
	currentUnitTurn.on_turn_start()

# Secret unit in last pos to end round
func make_unit_list():
	var unitList = unitMan.get_children()
	print("Children are ", unitList)
	var allyList = []
	var enemyList = []
	AutoloadMe.globalUnitList = unitList
	print("MAKING UNITLIST!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	sort_unit_list()
	for i in unitList.size():
		unitList[i].position = unitList[i].grid.map_to_local(unitList[i].grid.local_to_map(unitList[i].position))
		if unitList[i].get_faction() == unitList[i].fac.ALLY:
			allyList.append(AutoloadMe.globalUnitList[i])
		elif unitList[i].get_faction() == unitList[i].fac.ENEMY:
			enemyList.append(AutoloadMe.globalUnitList[i])
	
	AutoloadMe.globalAllyList = allyList
	AutoloadMe.globalEnemyList = enemyList
	SignalBus.updateInitBox.emit()
	print("UnitList: ", unitList)
	print("AllList: ", allyList)
	print("EnemyList: ", enemyList)

func add_unit_list(unit):
	AutoloadMe.globalUnitList.append(unit)
	sort_unit_list()
	
	if unit.get_faction() == unit.fac.ALLY:
		AutoloadMe.globalAllyList.append(unit)
		AutoloadMe.globalAllyList.sort_custom(func(a,b): return a.CurrentInit > b.CurrentInit)
	elif unit.get_faction() == unit.fac.ENEMY:
		AutoloadMe.globalEnemyList.append(unit)
		AutoloadMe.globalEnemyList.sort_custom(func(a,b): return a.CurrentInit > b.CurrentInit)
	
	SignalBus.addInitBox.emit(unit)

func get_unit_list():
	return AutoloadMe.globalUnitList

func sort_unit_list():
	AutoloadMe.globalUnitList.sort_custom(func(a,b): return a.CurrentInit > b.CurrentInit)

func get_current_turn():
	return currentUnitTurn
