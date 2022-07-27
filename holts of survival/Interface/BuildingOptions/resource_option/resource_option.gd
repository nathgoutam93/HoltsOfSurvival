extends "res://Interface/BuildingOptions/base_option/Options.gd"

signal collect

func _ready():
	$Options/collect.connect("pressed", self, "_on_collect_pressed")

func _on_collect_pressed():
	emit_signal("collect")
