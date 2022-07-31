extends Node

var game = null
var hud = null
var player = null setget _set_player

const ws_url = "wss://holtsofsurvival.herokuapp.com/api/"
var ws_client = WebSocketClient.new()
var ws_listners = {}

func _process(delta):
	ws_client.poll()

func _init_socket(access_token: String) -> void:
	if not is_processing():
		set_process(true)
	
	ws_client.connect("connection_closed", self, "_closed")
	ws_client.connect("connection_error", self, "_closed")
	ws_client.connect("connection_established", self, "_connected")
	ws_client.connect("data_received", self, "_on_data")
	
#	var header = "Authorization: %s" % access_token
#	var err = ws_client.connect_to_url(ws_url, [], false, [header])
	var err = ws_client.connect_to_url(ws_url, [], false)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _init_player(value: Dictionary) -> void:
	var player_instance = Player.new() 
	
	player_instance._set_name(value.username)
	player_instance._set_xp(value.xp)
	player_instance._set_trophy(value.trophy) 
	player_instance._set_townhall(value.townhall)
	player_instance._set_wood(value.wood) 
	player_instance._set_stone(value.stone)
	player_instance._set_buildings(value.buildings) 

	_set_player(player_instance)
	
	get_tree().change_scene("res://scenes/Game/Game.tscn")

func _set_player(value : Player) -> void:
	if value is Player:
		player = value
	else:
		return
	
	if game == null:
		return
	else:
		game.update_player()

	
##########################
######## WebSocket #######
##########################
func _on_ping(data):
	ws_emit("pong", "")

func _on_authenticate(data):
	ws_emit("Authenticate", Auth.access_token)

func ws_get() -> Dictionary:
	return parse_json(ws_client.get_peer(1).get_packet().get_string_from_utf8())

func ws_emit(event: String , data) -> void:
	ws_client.get_peer(1).put_packet(to_json({
		"event": event,
		"data": data
	}).to_utf8())

func ws_listen(event: String, callback: FuncRef) -> void:
	ws_listners[event] = callback

func _connected(proto := "") -> void:
	print("Connected with protocol: ", proto)
	
	ws_listen("ping", funcref(self, "_on_ping"))
	
	ws_listen("Authenticate", funcref(self, "_on_authenticate"))
	
	ws_listen("time", funcref(TimeManager, "set_time"))
	
	ws_listen("player", funcref(self, "_init_player"))
	
	ws_listen("message", funcref(GDScript, "print"))

func _on_data() -> void:
	var data = ws_get()
	
	ws_listners[data.event].call_func(data.data)

func _closed(was_clean = false) -> void:
	print("Closed, clean: ", was_clean)
	set_process(false)
	
	ws_client.disconnect("connection_closed", self, "_closed")
	ws_client.disconnect("connection_error", self, "_closed")
	ws_client.disconnect("connection_established", self, "_connected")
	ws_client.disconnect("data_received", self, "_on_data")
	
	var alert = AcceptDialog.new()
	alert.dialog_text = "You have lost Connection with the Server, Check your internet connection and try again"
	alert.connect("confirmed", self, "restart")
	alert.connect("modal_closed", self, "restart")
	hud.add_child(alert)
	alert.popup_centered()

func restart():
	get_tree().change_scene("res://scenes/SplashScreen/SplashScreen.tscn")

func close_socket_connection():
	ws_client.disconnect("connection_closed", self, "_closed")
	ws_client.disconnect("connection_error", self, "_closed")
	ws_client.disconnect("connection_established", self, "_connected")
	ws_client.disconnect("data_received", self, "_on_data")
	
	ws_client.disconnect_from_host()
