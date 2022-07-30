extends Node

class_name Player

signal wood_change
signal stone_change

var playerName : String setget _set_name
var xp : int setget _set_xp
var trophy : int setget _set_trophy
var townhall: int setget _set_townhall
var wood : int setget _set_wood, _get_wood
var stone : int setget _set_stone, _get_stone
var buildings : Dictionary setget _set_buildings, _get_buildings

func _set_name(value: String):
	playerName = value
	
func _set_xp(value: int):
	xp = value

func _set_trophy(value: int):
	trophy = value

func _set_townhall(value: int):
	townhall = value

func _set_wood(value: int):
	wood = clamp(value, 0, _total_wood_capacity())
	emit_signal("wood_change")
#
func _set_stone(value: int):
	stone = clamp(value, 0, _total_stone_capacity())
	emit_signal("stone_change")

func _get_wood():
	return wood

func _get_stone():
	return stone

func _set_buildings(value: Dictionary):
	buildings = value
	
func _get_buildings():
	return buildings

func _get_building_count(_class: int) -> int:
	var count = 0
	for building in buildings.values():
		if building.class == _class:
			count += 1
	return count
	
func _total_wood_capacity() -> int:
	var capacity : int = Constants.Buildings[Constants.Building.TOWN_HALL][townhall].capacity.wood
	for building in buildings.values():
		if building.class == Constants.Building.WOOD_STORAGE:
			capacity += Constants.Buildings[building.class][building.level].capacity
	return capacity
	
func _total_stone_capacity() -> int:
	var capacity : int = Constants.Buildings[Constants.Building.TOWN_HALL][townhall].capacity.stone
	for building in buildings.values():
		if building.class == Constants.Building.STONE_STORAGE:
			capacity += Constants.Buildings[building.class][building.level].capacity
	return capacity
