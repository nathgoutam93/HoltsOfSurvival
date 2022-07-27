extends Node2D

var selected_building = null setget _set_selected_building

func _ready():
	GameManager.game = self
	_init_world()
	GameManager.hud._set_counters()
	GameManager.player.connect("gold_change", GameManager.hud, "_on_gold_change")
	GameManager.player.connect("oil_change", GameManager.hud, "_on_oil_change")
	
func _init_world() -> void:
	var player = Player.new()
	
	if Constants.save_exist():
		var data = Constants.loadDictionary()
		player.townhall = data.townhall
		player.buildings = data.buildings
		player.gold = data.gold
		player.oil = data.oil
	else:
		var _id = Uuid.v4()
		player.townhall = 1
		player.oil = 5000
		player.gold = 5000
		player.buildings = {
			_id: {
				"id": _id,
				"class": 0,
				"level": 1,
				"pos": {
					"x": -64,
					"y": 480
				},
				"upgrade": {
					"status": false,
					"start": 0,
					"end": 0
				}
			},
		}
	GameManager.player = player
	for building in GameManager.player.buildings.values():
		var b_instance = _spawn_building(building)
		b_instance._set_selectable(true)
		$YSort.add_child(b_instance)

func _set_selected_building(building) -> void:
	if selected_building == null:
		selected_building = building
	else:
		selected_building.has_method("_hide_options") && selected_building._hide_options()
		selected_building = building
	
	if selected_building != null:
		selected_building.has_method("_show_options") && selected_building._show_options()

func _spawn_building(building):
	var b_instance = load(Constants.Buildings[int(building.class)].scene).instance()
	b_instance._id = building.id
	b_instance._class = building.class
	b_instance._level = building.level
	b_instance._pos = Vector2(building.pos.x, building.pos.y)
	b_instance.upgrade = building.upgrade
	b_instance.grid = $ground
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

func _quit_game():
	var dict = {
		"townhall" : GameManager.player.townhall,
		"buildings": GameManager.player.buildings,
		"gold": GameManager.player.gold,
		"oil": GameManager.player.oil,
	}
	Constants.saveDictionary(dict)
	get_tree().quit()
