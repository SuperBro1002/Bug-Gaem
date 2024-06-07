extends Node

var currentUnitTurn
var unitList
@onready var unitMan = $UnitManager
@onready var obsHold = get_node("../ObstacleHolder")

func _ready():
	make_unit_list()
	SignalBus.connect("endTurn", next_turn)
	SignalBus.connect("endRound", next_round)
	SignalBus.connect("remakeUnitList", make_unit_list)
	SignalBus.connect("addToUnitList", add_unit_list)

# Probably main function
func next_turn():
	PortraitManager.hide_main_portrait()
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
	if Dialogic.VAR.CutsceneUp == true:
		AutoloadMe.roundNum -= 1
		return
	Dialogic.VAR.StoryProgress += 1
	for j in (AutoloadMe.globalUnitList.size()):
		AutoloadMe.globalUnitList[j].reset_acted()
		AutoloadMe.globalUnitList[j].reset_ap()
	currentUnitTurn = AutoloadMe.globalUnitList[0]
	print("ROUND END. RESETTING: ", currentUnitTurn)
	SignalBus.currentUnit.emit(currentUnitTurn)
	SignalBus.midObjective.emit()
	print("herte")
	#await SignalBus.midObjectiveChecked
	print("theret")
	currentUnitTurn.on_turn_start()

# Secret unit in last pos to end round
func make_unit_list():
	unitList = unitMan.get_children()
	print("Children are ", unitList)
	var allyList = []
	var enemyList = []
	var targetList = obsHold.get_children()
	AutoloadMe.globalUnitList = unitList
	print("MAKING UNITLIST!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	sort_unit_list()
	
	for i in unitList.size():
		targetList.append(AutoloadMe.globalUnitList[i])
		
		if unitList[i].get_faction() == unitList[i].fac.ALLY:
			allyList.append(AutoloadMe.globalUnitList[i])
		elif unitList[i].get_faction() == unitList[i].fac.ENEMY:
			enemyList.append(AutoloadMe.globalUnitList[i])
	
	AutoloadMe.globalTargetList = targetList
	AutoloadMe.globalAllyList = allyList
	AutoloadMe.globalEnemyList = enemyList
	SignalBus.updateInitBox.emit()
	print("UnitList: ", unitList)
	print("AllList: ", allyList)
	print("EnemyList: ", enemyList)
	print("TARGETLIST: ", targetList)
	
	for i in targetList.size():
		targetList[i].position = targetList[i].grid.map_to_local(targetList[i].grid.local_to_map(targetList[i].position))

func add_unit_list(unit):
	AutoloadMe.globalUnitList.append(unit)
	AutoloadMe.globalTargetList.append(unit)
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
	unitList.sort_custom(func(a,b): return a.CurrentInit > b.CurrentInit)

func get_current_turn():
	return currentUnitTurn
