extends Control

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	$AnimationPlayer.play("fade")

func _go_AuthScreen():
	get_tree().change_scene("res://scenes/AuthScreen/AuthScreen.tscn")

func _on_AnimationPlayer_animation_finished(anim_name):
	if Auth.access_token.empty():
		_go_AuthScreen()
	else:
		GameManager.game = null
		GameManager.player = null
		GameManager.hud = null
		GameManager._init_socket(Auth.access_token)
