extends Node

var speed = 1.0

var time = OS.get_unix_time() setget set_time, get_time

func _ready():
	pass

func _process(delta):
	time += delta * speed

func set_time(value : int):
	time = value
	
func get_time():
	return floor(time)
