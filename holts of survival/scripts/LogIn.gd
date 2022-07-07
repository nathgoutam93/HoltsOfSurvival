extends Control

onready var username: LineEdit = $username_edit
onready var password: LineEdit = $password_edit
onready var notification: Label = $notification
onready var back_button: Button = $back_button
onready var log_in_button: Button = $log_in_button

onready var http_req: HTTPRequest = HTTPRequest.new()

func _ready():
	back_button.connect("pressed", self, "_return_to_auth")
	log_in_button.connect("pressed", self, "_log_in")
	add_child(http_req)
	http_req.connect("request_completed", self, "_log_in_completed")
	
func _return_to_auth():
	get_tree().change_scene("res://scenes/AuthScreen.tscn")
	
func _log_in():
	if username.text.empty() or password.text.empty():
		notification.text = "Invalid password or username"
		return
	Auth.login(username.text, password.text, http_req)
	
func _log_in_completed(result, response_code, headers, body):
	var response_body = JSON.parse(body.get_string_from_utf8()).result
	if response_code != 200:
		notification.text = response_body.error.message
	else:
		notification.text = "Logged In Successfully"
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://scenes/forest.tscn")
