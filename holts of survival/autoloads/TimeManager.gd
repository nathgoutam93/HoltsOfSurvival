extends Node

var speed = 1.0

var time = OS.get_unix_time() setget , get_time

func _ready():
	pass

func _process(delta):
	time += delta * speed

func get_time():
	return floor(time)
