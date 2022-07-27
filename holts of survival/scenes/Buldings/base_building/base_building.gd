extends Area2D

var message_label = preload("res://Interface/ShowMessage/show_message.tscn")
var select_sound = preload("res://assets/sounds/select.wav")
var upgrade_sound = preload("res://assets/sounds/upgrade.wav")
var coin_sound = preload("res://assets/sounds/coin.mp3")

signal select

var grid : TileMap = null

var edit := false setget _set_edit
var is_selectable := false setget _set_selectable
var is_moveable := true setget _set_is_moveable

var _id : String
var _class : int
var _level : int 
var _pos : Vector2
var _hitpoints : int
export var _tiles : int = 1

var upgrade = {
	"status": false,
	"start": 0,
	"end": 0
}

onready var _boundaries := Constants.Boundaries

func _ready():
	position = _pos
	_set_sprite()
	
	if upgrade.status:
		add_upgrade_label()
	
	# create select animation and add to animation player
	var pos_y = $Sprite.position.y
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "Sprite:position:y")
	animation.track_insert_key(track_index, 0.0, pos_y)
	animation.track_insert_key(track_index, 0.2, pos_y - 10)
	animation.track_insert_key(track_index, 0.4, pos_y)
	$AnimationPlayer.add_animation("select", animation)
	
func _process(delta):
	if edit:
		follow_cursor_with_snapping()
	if upgrade.status:
		if TimeManager.time > upgrade.end:
			upgrade_complete()

func _set_edit(value: bool) -> void:
	edit = value

func _set_selectable(value: bool):
	is_selectable = value

func follow_cursor_with_snapping() -> void:
#	var offset = Vector2(0.0, 16.0) * _tiles - Vector2(0.0, 16.0)
	var in_map_pos = grid.world_to_map(get_global_mouse_position())
	var cell_local_pos = grid.map_to_world(in_map_pos)
	var cell_global_position = grid.to_global(cell_local_pos)
	if global_position != cell_global_position:
		global_position = cell_global_position
		play_select()
	var moveability = check_moveability()
	
	if moveability != is_moveable:
		_set_is_moveable(moveability)

func play_select():	
	$Sound.set_stream(select_sound)
	$Sound.play()

func play_upgrade():
	$Sound.set_stream(upgrade_sound)
	$Sound.play()
	
func play_coin():
	$Sound.set_stream(coin_sound)
	$Sound.play()

func _set_sprite() -> void:
	$Sprite.texture = load(Constants.Buildings[_class][_level].sprites.idle)

func _set_is_moveable(value: bool) -> void:
	is_moveable = value
	
	var color := Color(0, 1, 0, 1) if value else Color(1, 0, 0, 1)
	$Tile.material.set_shader_param("color", color)

func _enable_edit_mode() -> void:
	_set_edit(true);
	$Tile.material.set_shader_param("overlay", true)

func _edit_complete() -> void:
	_set_edit(false)
	if is_moveable:
		_pos = global_position
		update_pos()
		$Tile.material.set_shader_param("overlay", false)
	else:
		_edit_cancle()

func _edit_cancle() -> void:
	global_position = _pos
	$Tile.material.set_shader_param("overlay", false)
	$Sprite.material.set_shader_param("pulsing", false)

func _upgrade_level() -> void:
	var level_to_upgrade = _level + 1
	if not Constants.Buildings[_class].has(level_to_upgrade):
		var message = message_label.instance()
		message.set_message("Nothing to Upgrade")
		GameManager.hud.add_child(message)
	else:
		if is_able_to_upgrade(level_to_upgrade):
			var upgrade_cost = Constants.Buildings[_class][level_to_upgrade].cost
			var success = deduct_resource(upgrade_cost.resource, upgrade_cost.amount)
			
			if success:
				upgrade.status = true
				upgrade.start = TimeManager.get_time()
				upgrade.end = upgrade.start + Constants.Buildings[_class][level_to_upgrade].build_time
			
				add_upgrade_label()

func add_upgrade_label():
	var upgrade_status = load("res://Interface/UpgradeStatus/upgrade_status.tscn").instance()
	upgrade_status.time_of_upgrade_complete = upgrade.end
	add_child(upgrade_status)

func remove_upgrade_label():
	get_node("UpgradeStatus").queue_free()

func is_able_to_upgrade(level_to_upgrade) -> bool:
	var townhall_required = Constants.Buildings[_class][level_to_upgrade].townhall_required
	
	if GameManager.player.townhall < townhall_required:
		var message = message_label.instance()
		message.set_message("required townhall level "+ str(townhall_required))
		GameManager.hud.add_child(message)
		return false
	
	return true
	
func deduct_resource(resource, amount) -> bool:
	if GameManager.player[resource] < amount:
		var message = message_label.instance()
		message.set_message("Resource is not sufficient")
		GameManager.hud.add_child(message)
		return false
	
	if resource == "gold":
		GameManager.player._set_gold(GameManager.player._get_gold() - amount)
		play_coin()
	else:
		GameManager.player._set_oil(GameManager.player._get_oil() - amount)

	return true
	
func upgrade_complete():
	upgrade.status = false
	upgrade.start = 0
	upgrade.end = 0
	_level += 1
	remove_upgrade_label()
	update_level()
	play_upgrade()
	_set_sprite()

func _hide_options():
	$Sprite.material.set_shader_param("pulsing", false)
	
	$Options.disconnect("upgrade", self, "_on_upgrade_pressed")
	$Options.has_method("_hide_option") && $Options._hide_option()

func _show_options():
	$AnimationPlayer.play("select")
	play_select()
	$Sprite.material.set_shader_param("pulsing", true)
	
	$Options.connect("upgrade", self, "_on_upgrade_pressed")
	$Options.has_method("_show_option") && $Options._show_option()

func _on_upgrade_pressed():
	_upgrade_level()

func check_moveability():
	var rect = Rect2(grid.world_to_map(position), Vector2(_tiles, _tiles))
	return not (get_overlapping_areas().size() > 0 or rect.position.x < _boundaries.position.x or rect.end.x > _boundaries.end.x or rect.position.y < _boundaries.position.y or rect.end.y > _boundaries.end.y)

func update_pos():
	GameManager.player.buildings[_id].pos = {
		"x": position.x,
		"y": position.y
	}

func update_upgrade():
	GameManager.player.buildings[_id].update = upgrade

func update_level():
	GameManager.player.buildings[_id].level = _level

func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_left"):
		if is_selectable && GameManager.game.selected_building != self:
			emit_signal("select", self)
		elif edit:
			_edit_complete()
		else:
			_enable_edit_mode()
