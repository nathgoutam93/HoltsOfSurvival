extends Node

const LOG_IN_URL = "http://localhost:3000/api/signin"
const SIGN_UP_URL = "http://localhost:3000/api/signup"

var current_user = null

func _make_post_request(http: HTTPRequest, url: String, data_to_send, use_ssl: bool):
	var query = to_json(data_to_send)
	var headers = ["Content-Type: application/json"]
	http.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)
	
func get_result(result: Array):
	var result_body = JSON.parse(result[3].get_string_from_utf8()).result as Dictionary
	return result_body
	
func register(username: String, password: String, http: HTTPRequest) -> void:
	var body = {
		"username": username,
		"password": password
		}
	_make_post_request(http, SIGN_UP_URL, body, false)
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		current_user = get_result(result)
		
func login(username: String, password: String, http: HTTPRequest) -> void:
	var body = {
		"username": username,
		"password": password
		}
	_make_post_request(http, LOG_IN_URL, body, false)
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		current_user = get_result(result)
