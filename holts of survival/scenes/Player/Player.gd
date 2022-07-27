extends Node

class_name Player

signal gold_change
signal oil_change

var playerName : String
var xp : int
var trophy : int
var townhall: int
var gold : int setget _set_gold, _get_gold
var oil : int setget _set_oil, _get_oil
var buildings : Dictionary

func _init(_name := "player", _xp := 100, _trophy := 50, _gold := 100, _oil:= 100):
	playerName = _name
	xp = _xp
	trophy = _trophy
	gold = _gold
	oil = _oil

func _get_building_count(_class: int) -> int:
	var count = 0
	for building in buildings.values():
		if building.class == _class:
			count += 1
	return count
	
func _total_gold_capacity() -> int:
	var capacity : int = Constants.Buildings[Constants.Building.TOWN_HALL][townhall].capacity.gold
	for building in buildings.values():
		if building.class == Constants.Building.GOLD_STORAGE:
			capacity += Constants.Buildings[building.class][building.level].capacity
	return capacity
	
func _total_oil_capacity() -> int:
	var capacity : int = Constants.Buildings[Constants.Building.TOWN_HALL][townhall].capacity.oil
	for building in buildings.values():
		if building.class == Constants.Building.OIL_STORAGE:
			capacity += Constants.Buildings[building.class][building.level].capacity
	return capacity

#func _add_gold(value: int):
#	_set_gold(gold - value)
#
#func _add_elixer(value: int):
#	_set_elixer(elixer - value)
#
#func _remove_gold(value: int):
#	_set_gold(gold - value)
#
#func _remove_elixer(value: int):
#	_set_elixer(elixer - value)
#
func _set_gold(value: int):
	gold = value
	emit_signal("gold_change")
#
func _set_oil(value: int):
	oil = value
	emit_signal("oil_change")

func _get_gold():
	return gold

func _get_oil():
	return oil
