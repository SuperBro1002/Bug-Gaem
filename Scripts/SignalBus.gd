extends Node

signal hasMoved(unit, pos)
signal startTurn
signal endTurn
signal currentUnit
signal endRound
signal deletePassives
signal updateGrid
signal currOppFac(affil)
signal ability(abilityNum, state)
signal activelyQueueing(status)
signal abilityIsQueued
signal abilityExecuted(ability)
signal updateUI
signal changeButtonState
signal updateInitBox
signal deleteInitObject
signal adjustZoom
signal moveCamera
signal deleteMe(unit)
signal actedUI
signal updateFloatingHP
signal updateFloatingAP
signal mouseHovering(isHovering)
signal remakeUnitList
signal spawnGroup
signal checkEvents
