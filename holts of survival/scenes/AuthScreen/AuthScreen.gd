extends Control

func _ready():
	$login_button.connect("pressed", self, "_on_login_button_pressed")
	$signup_button.connect("pressed", self, "_on_signup_button_pressed")

func _on_login_button_pressed():
	_go_loginScreen()

func _on_signup_button_pressed():
	_go_registerScreen()

func _go_loginScreen():
	get_tree().change_scene("res://scenes/LogInScreen/LogIn.tscn")

func _go_registerScreen():
	get_tree().change_scene("res://scenes/RegisterScreen/Register.tscn")
