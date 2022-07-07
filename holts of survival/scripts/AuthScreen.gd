extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_login_button_pressed():
	get_tree().change_scene("res://scenes/LogIn.tscn")

func _on_signup_button_pressed():
	get_tree().change_scene("res://scenes/Register.tscn")
