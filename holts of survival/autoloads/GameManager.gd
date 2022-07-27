extends Node

var game = null
var hud = null
var player = null setget _set_player

const ws_url = "ws://localhost:3000/api/"
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
	
	var header = "Authorization: %s" % access_token
	var err = ws_client.connect_to_url(ws_url, [], false, [header])
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _init_player(value: Dictionary) -> void:
	var player_instance = Player.new() 
	
	player_instance.name = value.username
	player_instance.xp = value.xp
	player_instance.trophy = value.trophy
	player_instance.townhall = value.townhall
	player_instance.buildings = parse_json(value.buildings) as Dictionary
	player_instance.gold = value.gold
	player_instance.oil = value.oil

	_set_player(player_instance)
	
#	get_tree().change_scene("res://scenes/Game/Game.tscn")

func _set_player(value : Player) -> void:
	if value is Player:
		player = value
	else:
		return

##########################
######## WebSocket #######
##########################

func ws_get() -> Dictionary:
	return parse_json(ws_client.get_peer(1).get_packet().get_string_from_utf8())

func ws_emit(event: String , data = {} ) -> void:
	ws_client.get_peer(1).put_packet(to_json({
		"event": event,
		"data": data
	}).to_utf8())

func ws_listen(event: String, callback: FuncRef) -> void:
	ws_listners[event] = callback

func _connected(proto := "") -> void:
	print("Connected with protocol: ", proto)
	
	ws_listen("player", funcref(self, "_init_player"))
	
	ws_listen("message", funcref(GDScript, "print"))
	
	ws_emit("player")

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
	alert.set_autowrap(true)
	alert.connect("confirmed", self, "_restart")
	alert.connect("modal_closed", self, "_restart")
	add_child(alert)
	alert.popup_centered()

func _restart():
	get_tree().change_scene("res://scenes/SplashScreen/SplashScreen.tscn")
