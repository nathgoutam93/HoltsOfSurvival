extends Control

onready var http_req: HTTPRequest = HTTPRequest.new()

func _ready():
	$back_button.connect("pressed", self, "_return_to_auth")
	$sign_up_button.connect("pressed", self, "_sign_up")
	add_child(http_req)
	http_req.connect("request_completed", self, "_sign_up_completed")

func _return_to_auth():
	get_tree().change_scene("res://scenes/AuthScreen/AuthScreen.tscn")

func _sign_up():
	if $password_edit.text != $confirm_password_edit.text or $username_edit.text.empty() or $password_edit.text.empty():
		$notification.text = "Invalid password or username"
		return
	Auth.register($username_edit.text, $password_edit.text, http_req)
	
func _sign_up_completed(result, response_code, headers, body):
	var response_body = JSON.parse(body.get_string_from_utf8()).result
	if response_code != 200:
		if response_body != null:
			$notification.text = response_body.error.message
		else:
			$notification.text = "failed to connect"
	else: 
		$notification.text = "User Registered Successfully"
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene("res://scenes/LogInScreen/LogIn.tscn")
