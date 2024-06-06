extends "res://Scripts/obstacle.gd"

func delete(unit):
	if unit == self:
		print("SIPHON IS DYING")
		SignalBus.playSFX.emit("Death")
		AutoloadMe.siphonsDestroyed += 1
		SignalBus.quickSwap.emit(str("Lifeline-Phase ", AutoloadMe.siphonsDestroyed+1))
		AutoloadMe.globalTargetList.erase(unit)
		SignalBus.updateGrid.emit()
		SignalBus.deleteMe.emit(self)
		queue_free()
