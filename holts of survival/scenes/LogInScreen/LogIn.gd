extends Control

onready var http_req: HTTPRequest = HTTPRequest.new()

func _ready():
	$back_button.connect("pressed", self, "_return_to_auth")
	$log_in_button.connect("pressed", self, "_log_in")
	add_child(http_req)
	http_req.connect("request_completed", self, "_log_in_completed")

func _return_to_auth():
	get_tree().change_scene("res://scenes/AuthScreen/AuthScreen.tscn")

func _log_in():
	if $username_edit.text.empty() or $password_edit.text.empty():
		$notification.text = "Invalid password or username"
		return
	Auth.login($username_edit.text, $password_edit.text, http_req)

func _log_in_completed(result, response_code, headers, body):
	var response_body = parse_json(body.get_string_from_utf8())
	if response_code != 200:
		$notification.text = response_body.error.message
	else:
		$notification.text = "Logged In Successfully"
