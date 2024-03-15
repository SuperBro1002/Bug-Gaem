extends Node

var unitList
var allyList = []
var currentUnitTurn
@onready var unitMan = $UnitManager

func _ready():
	make_unit_list()
	SignalBus.connect("endTurn", next_turn)
	SignalBus.connect("endRound", next_round)

# Probably main function
func next_turn():
	for i in (unitList.size()):
		if unitList[i].get_batonpass() == unitList[i].TS.BATONPASS:
			currentUnitTurn = unitList[i]
			#print("FOUND BATON PASS TARGET: ", currentUnitTurn)
			SignalBus.currentUnit.emit(currentUnitTurn)
			currentUnitTurn.on_turn_start()
			return
		elif unitList[i].get_batonpass() == unitList[i].TS.NOTACTED:
			currentUnitTurn = unitList[i]
			#print("FOUND NORMAL TARGET: ", currentUnitTurn)
			SignalBus.currentUnit.emit(currentUnitTurn)
			currentUnitTurn.on_turn_start()
			return

func next_round():
	for j in (unitList.size()):
		unitList[j].reset_acted()
	currentUnitTurn = unitList[0]
	print("ROUND END. RESETTING: ", currentUnitTurn)
	SignalBus.currentUnit.emit(currentUnitTurn)
	currentUnitTurn.on_turn_start()

# Secret unit in last pos to end round
func make_unit_list():
	unitList = unitMan.get_children()
	sort_unit_list()
	
	for i in unitList.size():
		if unitList[i].get_faction() == unitList[i].fac.ALLY:
			allyList.append(unitList[i])
	
	AutoloadMe.globalAllyList = allyList
	AutoloadMe.globalUnitList = unitList
	SignalBus.updateInitBox.emit()
	print("UnitList: ", unitList)
	print("AllList: ", allyList)

func get_unit_list():
	return unitList

func sort_unit_list():
	unitList.sort_custom(func(a,b): return a.CurrentInit > b.CurrentInit)

func get_current_turn():
	return currentUnitTurn
