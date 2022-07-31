extends Node2D

var selected_building = null setget _set_selected_building

func _ready():
#	var player = Player.new()
#	var _id = Uuid.v4()
#	player.townhall = 1
#	player.stone = 1000
#	player.wood = 1000
#	player.buildings = {
#		_id: {
#			"id": _id,
#			"class": 0,
#			"level": 1,
#			"pos": {
#				"x": -64,
#				"y": 480
#			},
#			"upgrade": {
#				"status": false,
#				"start": 0,
#				"end": 0
#			}
#		},
#	}
#	GameManager.player = player
	GameManager.ws_emit("time","")
	GameManager.game = self
	GameManager.hud._set_counters()
	GameManager.player.connect("wood_change", GameManager.hud, "_on_wood_change")
	GameManager.player.connect("stone_change", GameManager.hud, "_on_stone_change")
	_init_world()
	
func _init_world() -> void:
	for building in GameManager.player.buildings.values():
		var b_instance = _spawn_building(building)
		b_instance._set_selectable(true)
		$YSort.add_child(b_instance)

func _set_selected_building(building) -> void:
	if selected_building == null:
		selected_building = building
	else:
		selected_building.has_method("hide_options") && selected_building.hide_options()
		selected_building = building
	
	if selected_building != null:
		selected_building.has_method("show_options") && selected_building.show_options()

func _spawn_building(building):
	var b_instance = load(Constants.Buildings[int(building.class)].scene).instance()
	b_instance._id = building.id
	b_instance._class = building.class
	b_instance._level = building.level
	b_instance._pos = Vector2(building.pos.x, building.pos.y)
	b_instance.grid = $Ground
	b_instance.connect("select", self, "_on_select")
	return b_instance

func _on_select(building) -> void:
	_set_selected_building(building)

func _unhandled_input(event):
	if event.is_action_pressed("mouse_right") && selected_building != null:
		_set_selected_building(null)

func _unhandled_key_input(event):
	if event.is_action_pressed("exit_game"):
		_confirm_quit()

func _confirm_quit():
	var alert = ConfirmationDialog.new()
	alert.dialog_text = "You want quit the Game?"
	alert.connect("confirmed", self, "_quit_game")
	$HUD.add_child(alert)
	alert.popup_centered()

func update_player():
	var dict = {
		"username": GameManager.player.playerName,
		"xp": GameManager.player.xp,
		"trophy": GameManager.player.trophy,
		"townhall" : GameManager.player.townhall,
		"buildings": GameManager.player.buildings,
		"wood": GameManager.player.wood,
		"stone": GameManager.player.stone,
	}
	GameManager.ws_emit("update",dict)

func _quit_game():
	GameManager.game = null
	GameManager.hud = null
	GameManager.player = null
	GameManager.close_socket_connection()
	yield(get_tree().create_timer(0.5),"timeout")
	get_tree().change_scene("res://scenes/AuthScreen/AuthScreen.tscn")
