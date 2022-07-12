extends CanvasLayer

signal move
signal upgrade

func _ready():
	pass

func _process(delta):
	$Label.text = "FPS: " + String(Engine.get_frames_per_second())
