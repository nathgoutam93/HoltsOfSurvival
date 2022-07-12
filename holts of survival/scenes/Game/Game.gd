extends Node2D

const Buildings = [
	{
		"class": 0,
		"level": 1,
		"pos": {
			"x": 256,
			"y": 256
		}
	},
	{
		"class": 1,
		"level": 1,
		"pos": {
			"x": 128,
			"y": 128
		}
	},
	{
		"class": 2,
		"level": 1,
		"pos": {
			"x": 256,
			"y": 128
		}
	}
]

var Building = preload("res://scenes/Bulding/Building.tscn")

var selected_building = null setget _set_selected_building

func _ready():
	_init_world()

func _init_world():
	for building in GameManager.player.buildings:
		_spawn_building(building.class, building.level, Vector2(building.pos.x, building.pos.y))

func _set_selected_building(building):
	if building == null:
		selected_building._hide_options()
		selected_building = null
	else:
		selected_building = building
		selected_building._show_options()

func _spawn_building(id: int, level : int, position: Vector2):
	var b_instance = Building.instance()
	b_instance.grid = $grid
	b_instance._id = id
	b_instance._level = level
	b_instance._pos = position
	b_instance.connect("select", self, "_on_select")
	add_child(b_instance)

func _on_select(building):
	_set_selected_building(building)

func _unhandled_input(event):
	if event.is_action_pressed("mouse_left"):
		if selected_building == null:
			return
		elif selected_building.edit:
			selected_building._edit_complete()
			get_tree().get_root().set_input_as_handled()
		else:
			_set_selected_building(null)
	
	if event.is_action_pressed("mouse_right"):
		if selected_building == null:
			return
		elif selected_building.edit:
			selected_building._edit_cancle()
			get_tree().get_root().set_input_as_handled()
		else:
			_set_selected_building(null)
			get_tree().get_root().set_input_as_handled()
	
func _unhandled_key_input(event):
	if event.is_action_pressed("exit_game"):
		_confirm_quit()

func _confirm_quit():
	var alert = ConfirmationDialog.new()
	alert.dialog_text = "You want quit the Game?"
	alert.connect("confirmed", self, "_quit_game")
	HUD.add_child(alert)
	alert.popup_centered()

func _quit_game():
	get_tree().quit()
