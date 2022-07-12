extends Node

class_name Player

signal gold_change
signal elixer_change

var playerName : String
var xp : int
var trophy : int
var gold : int setget _set_gold
var elixer : int setget _set_elixer
var buildings : Array

func _init(name := "player", xp := 100, trophy := 50, gold := 100, elixer:= 100, buildings:= [Constants.Buildings[Constants.Building.TOWN_HALL]]):
	playerName = name
	xp = xp
	trophy = trophy
	gold = gold
	elixer = elixer
	
func _remove_gold(value: int):
	_set_gold(gold - value)

func _remove_elixer(value: int):
	_set_elixer(elixer - value)
	
func _set_gold(value: int):
	gold = value
	emit_signal("gold_change", gold)

func _set_elixer(value: int):
	elixer = value
	emit_signal("elixer_change", elixer)
