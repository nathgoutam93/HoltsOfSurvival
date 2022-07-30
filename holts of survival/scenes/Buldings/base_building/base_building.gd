extends Area2D

signal select

export var Options : PackedScene = preload("res://Interface/BuildingOptions/base_option/Options.tscn")

var InfoPanel = preload("res://Interface/InfoPanel/info_panel.tscn")
var UpgradePanel = preload("res://Interface/UpgradePanel/upgrade_panel.tscn")
var BuildingInfo = preload("res://Interface/BuildingInfo.tscn")
var MessageLabel = preload("res://Interface/ShowMessage/show_message.tscn")
var SelectSound = preload("res://assets/sounds/select.wav")
var UpgradeSound = preload("res://assets/sounds/upgrade.wav")
var CoinSound = preload("res://assets/sounds/coin.mp3")

var grid : TileMap = null

var edit := false setget _set_edit
var is_selectable := false setget _set_selectable
var is_moveable := true setget _set_is_moveable

var _id : String
var _class : int
var _level : int 
var _pos : Vector2
var _upgrade = {
	"status": false,
	"start": 0,
	"end": 0
}

export var _tiles : int = 1
onready var _boundaries := Constants.Boundaries

func _ready():
	position = _pos
	set_sprite()
	
	if _upgrade.status:
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
	if _upgrade.status:
		if TimeManager.time > _upgrade.end:
			upgrade_complete()

func _input(event):
	if event.is_action_released("mouse_left") && edit:
		edit_complete()
	
func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_left"):
		if is_selectable && GameManager.game.selected_building != self:
			emit_signal("select", self)
		elif edit:
			edit_complete()
		else:
			enable_edit_mode()

func enable_edit_mode() -> void:
	_set_edit(true);
	$Tile.material.set_shader_param("overlay", true)

func edit_complete() -> void:
	_set_edit(false)
	if is_moveable:
		_pos = global_position
		update_pos()
		$Tile.material.set_shader_param("overlay", false)
	else:
		edit_cancle()

func edit_cancle() -> void:
	global_position = _pos
	$Tile.material.set_shader_param("overlay", false)
	$Sprite.material.set_shader_param("pulsing", false)

func set_sprite() -> void:
	$Sprite.texture = load(Constants.Buildings[_class][_level].sprites.idle)

func follow_cursor_with_snapping() -> void:
	var in_map_pos = grid.world_to_map(get_global_mouse_position())
	var cell_local_pos = grid.map_to_world(in_map_pos)
	var cell_global_position = grid.to_global(cell_local_pos)
	if global_position != cell_global_position:
		global_position = cell_global_position
		play_sound(SelectSound)
	var moveability = check_moveability()
	
	if moveability != is_moveable:
		_set_is_moveable(moveability)

func check_moveability():
	var rect = Rect2(grid.world_to_map(position), Vector2(_tiles, _tiles))
	return not (get_overlapping_areas().size() > 0 or rect.position.x < _boundaries.position.x or rect.end.x > _boundaries.end.x or rect.position.y < _boundaries.position.y or rect.end.y > _boundaries.end.y)

func hide_options():
	$Sprite.material.set_shader_param("pulsing", false)
	remove_child(get_node("BuildingInfo"))
	remove_options()

func show_options():
	animate_select()
	$Sprite.material.set_shader_param("pulsing", true)
	add_info()
	add_options()

func animate_select():
	$AnimationPlayer.play("select")
	play_sound(SelectSound)

func add_info():
	var building_info = BuildingInfo.instance()
	building_info.get_node("name").text = "{name}".format({"name": Constants.Buildings[_class].name})
	building_info.get_node("level").text = "Level {level}".format({"level": _level })
	add_child(building_info)

func add_options():
	var building_options = Options.instance()
	building_options.connect("info", self, "_on_info_panel")
	building_options.connect("upgrade", self, "_on_upgrade_panel")
	add_child(building_options)

func remove_options():
	get_node("Options").disconnect("info", self, "_on_info_panel")
	get_node("Options").disconnect("upgrade", self, "_on_upgrade_panel")
	get_node("Options").has_method("_hide_option") && get_node("Options")._hide_option()

func _on_info_panel():
	var info_panel = InfoPanel.instance()
	info_panel._class = _class
	info_panel._level = _level
	hide_options()
	GameManager.hud.add_child(info_panel)

func _on_upgrade_panel():
	var upgrade_panel = UpgradePanel.instance()
	upgrade_panel._class = _class
	upgrade_panel.level_to_upgrade = _level + 1
	upgrade_panel.connect("upgrade_confirm", self, "upgrade_level")
	hide_options()
	GameManager.hud.add_child(upgrade_panel)

func upgrade_level() -> void:
	var level_to_upgrade = _level + 1
	if not Constants.Buildings[_class].has(level_to_upgrade):
		var message_label = MessageLabel.instance()
		message_label.set_message("Nothing to Upgrade")
		GameManager.hud.add_child(message_label)
	else:
		if is_able_to_upgrade(level_to_upgrade):
			var upgrade_cost = Constants.Buildings[_class][level_to_upgrade].cost
			var success = deduct_resource(upgrade_cost.resource, upgrade_cost.amount)
			
			if success:
				_upgrade.status = true
				_upgrade.start = TimeManager.get_time()
				_upgrade.end = _upgrade.start + Constants.Buildings[_class][level_to_upgrade].build_time
			
				add_upgrade_label()

func is_able_to_upgrade(level_to_upgrade) -> bool:
	var townhall_required = Constants.Buildings[_class][level_to_upgrade].townhall_required
	
	if GameManager.player.townhall < townhall_required:
		var message_label = MessageLabel.instance()
		message_label.set_message("required townhall level "+ str(townhall_required))
		GameManager.hud.add_child(message_label)
		return false
	
	return true

func deduct_resource(resource, amount) -> bool:
	if GameManager.player[resource] < amount:
		var message_label = MessageLabel.instance()
		message_label.set_message("Resource is not sufficient")
		GameManager.hud.add_child(message_label)
		return false
	
	if resource == "wood":
		GameManager.player.wood = (GameManager.player._get_wood() - amount)
		play_sound(CoinSound)
	else:
		GameManager.player.stone = (GameManager.player._get_stone() - amount)

	return true

func add_upgrade_label():
	var upgrade_status = load("res://Interface/UpgradeStatus/upgrade_status.tscn").instance()
	upgrade_status.time_of_upgrade_complete = _upgrade.end
	add_child(upgrade_status)

func remove_upgrade_label():
	get_node("UpgradeStatus").queue_free()

func upgrade_complete():
	_upgrade.status = false
	_upgrade.start = 0
	_upgrade.end = 0
	_level += 1
	remove_upgrade_label()
	update_level()
	play_sound(UpgradeSound)
	set_sprite()

func update_pos():
	GameManager.player.buildings[_id].pos = {
		"x": position.x,
		"y": position.y
	}

func update_upgrade():
	GameManager.player.buildings[_id].upgrade = _upgrade

func update_level():
	GameManager.player.buildings[_id].level = _level

func _set_edit(value: bool) -> void:
	edit = value

func _set_selectable(value: bool):
	is_selectable = value

func _set_is_moveable(value: bool) -> void:
	is_moveable = value
	
	var color := Color(0, 1, 0, 1) if value else Color(1, 0, 0, 1)
	$Tile.material.set_shader_param("color", color)

func play_sound(sound: AudioStream):
	$Sound.stream != sound && $Sound.set_stream(sound)
	$Sound.play()
