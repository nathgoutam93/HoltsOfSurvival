extends Control

onready var username: LineEdit = $username_edit
onready var password: LineEdit = $password_edit
onready var confirm_password: LineEdit = $confirm_password_edit
onready var back_button: Button = $back_button
onready var sign_up_button: Button = $sign_up_button
onready var notification: Label = $notification

onready var http_req: HTTPRequest = HTTPRequest.new()

func _ready():
	back_button.connect("pressed", self, "_return_to_auth")
	sign_up_button.connect("pressed", self, "_sign_up")
	add_child(http_req)
	http_req.connect("request_completed", self, "_sign_up_completed")

func _return_to_auth():
	get_tree().change_scene("res://scenes/AuthScreen.tscn")

func _sign_up():
	if password.text != confirm_password.text or username.text.empty() or password.text.empty():
		notification.text = "Invalid password or username"
		return
	Auth.register(username.text, password.text, http_req)
	
func _sign_up_completed(result, response_code, headers, body):
	var response_body = JSON.parse(body.get_string_from_utf8()).result
	if response_code != 200:
		notification.text = response_body.error.message
	else:
		notification.text = "User Registered Successfully"
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://scenes/LogIn.tscn")
