extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	$AnimationPlayer.play("fade")

func _go_AuthScreen():
	get_tree().change_scene("res://scenes/AuthScreen.tscn")

func _on_AnimationPlayer_animation_finished(anim_name):
	_go_AuthScreen()
