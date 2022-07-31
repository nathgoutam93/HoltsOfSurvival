extends Node

const LOG_IN_URL = "https://holtsofsurvival.herokuapp.com/api/signin"
const SIGN_UP_URL = "https://holtsofsurvival.herokuapp.com/api/signup"

var access_token := "" setget _set_access_token

func _set_access_token(value: String):
	if value.empty():
		return
		
	access_token = value

	GameManager._init_socket(access_token)

func _make_post_request(url: String, use_ssl: bool, data_to_send : Dictionary, http: HTTPRequest) -> void:
	var query = to_json(data_to_send)
	var headers = ["Content-Type: application/json"]
	http.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)
	
func get_result(result: Array):
	var result_body = JSON.parse(result[3].get_string_from_utf8()).result as Dictionary
	return result_body.data
	
func register(username: String, password: String, http: HTTPRequest) -> void:
	var body = {
		"username": username,
		"password": password
		}
	_make_post_request(SIGN_UP_URL, false, body, http)
		
func login(username: String, password: String, http: HTTPRequest) -> void:
	var body = {
		"username": username,
		"password": password
		}
	_make_post_request(LOG_IN_URL, false, body, http)
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		_set_access_token(get_result(result)) 
