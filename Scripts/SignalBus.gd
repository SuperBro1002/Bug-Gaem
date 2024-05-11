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
signal showUI
signal HpUiFinish # Emitted when floating_hp_bar.gd finishes decrementing health bar
signal showRangeTiles(name)
signal endRangeTiles
signal changeButtonState
signal updateInitBox
signal addInitBox(initBox)
signal deleteInitObject
signal adjustZoom
signal moveCamera
signal deleteMe(unit)
signal deleteUnit(unit)
signal actedUI
signal updateFloatingHP
signal updateFloatingAP
signal mouseHovering(isHovering)
signal remakeUnitList
signal addToUnitList(unit)
signal spawnGroup(id)
signal changeMainPortrait(filename)
signal changeReplyPortrait(filename)
signal checkEvents
