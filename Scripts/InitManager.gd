extends Node

var unitList
var currentUnitTurn
@onready var unitMan = $UnitManager

func _ready():
	make_unit_list()
	SignalBus.connect("endTurn", next_turn)
	SignalBus.connect("endRound", next_round)

# Probably main function
func next_turn():
	for i in (unitList.size()):
		#print("CURRENT INDEX: ",i)
		if unitList[i].get_batonpass() == 1:
			currentUnitTurn = unitList[i]
			print("FOUND BATON PASS TARGET", currentUnitTurn)
			SignalBus.currentUnit.emit(currentUnitTurn)
			currentUnitTurn.onTurnStart()
			return
		elif unitList[i].get_batonpass() == 0:
			currentUnitTurn = unitList[i]
			print("FOUND NORMAL TARGET", currentUnitTurn)
			SignalBus.currentUnit.emit(currentUnitTurn)
			currentUnitTurn.onTurnStart()
			return

func next_round():
	for j in (unitList.size()):
		unitList[j].set_batonpass(0)
	currentUnitTurn = unitList[0]
	print("ROUND END. RESETTING", currentUnitTurn)
	SignalBus.currentUnit.emit(currentUnitTurn)
	currentUnitTurn.onTurnStart()

# Secret unit in last pos to end round
func make_unit_list():
	unitList = unitMan.get_children()
	sort_unit_list()
	print(unitList)

func get_unit_list():
	return unitList

func sort_unit_list():
	unitList.sort_custom(func(a,b): return a.CurrentInit > b.CurrentInit)

func get_current_turn():
	return currentUnitTurn
