extends Area2D

signal select

var grid : TileMap = null

var edit := false setget _set_edit

func _ready():
	self.connect("input_event", self, "_on_Node2D_input_event")

func _process(delta):
	if edit:
		follow_cursor_with_snapping()

func _set_edit(value: bool):
	edit = value

func follow_cursor_with_snapping():
	var in_map_pos = grid.world_to_map(get_global_mouse_position())
	var cell_local_pos = grid.map_to_world(in_map_pos)
	var cell_global_position = grid.to_global(cell_local_pos)
	global_position = cell_global_position

func _on_Node2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_left"):
		emit_signal("select", self)
