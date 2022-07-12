extends "res://scenes/Bulding/grid_item.gd"

const boundaries := Constants.Boundaries

var _id : int
var _level : int 
var _pos : Vector2 
var _hitpoints: int

var is_moveable := true setget _set_is_moveable

func _ready():
	$Sprite.texture = load(Constants.Buildings[_id][_level].sprite)
	$Options.connect("move", self, "_on_move_pressed")
	$Options.connect("upgrade", self, "_on_upgrade_pressed")
	global_position = _pos

func _set_is_moveable(value: bool):
	
	is_moveable = value
	
	# update the sprite outline color based on moveability 
	var color := Color(0, 1, 0, 1) if value else Color(1, 0, 0, 1)
	$Sprite.material.set_shader_param("color", color)
	
func _enable_edit_mode():
#	get self position in screen space and move mouse to that position 
	var offset = Vector2(8, 8)
	Input.warp_mouse_position(get_global_transform_with_canvas().origin + offset)
	
	var color := Color(0, 1, 0, 1) if is_moveable else Color(1, 0, 0, 1)
	$Sprite.material.set_shader_param("color", color)
	$Sprite.material.set_shader_param("pulsing", true)
	
	yield(get_tree().create_timer(0.2),"timeout")
	_set_edit(true)
	
func _edit_complete():
	if is_moveable:
#	set position of this node to this currently edited position
		_pos = global_position
		_set_edit(false)
		$Sprite.material.set_shader_param("color", Color(1,1,1,0))
		$Sprite.material.set_shader_param("pulsing", false)
	else:
		_edit_cancle()

func _edit_cancle():
#	set global_position back to its initial position of start moving
	global_position = _pos
	_set_edit(false)
	
	$Sprite.material.set_shader_param("color", Color(1,1,1,0))
	$Sprite.material.set_shader_param("pulsing", false)

func _upgrade_level():
	
	if _level < Constants.Buildings[_id].max_level:
		_level += 1
		$Sprite.texture = load(Constants.Buildings[_id][_level].sprite)
#
func _hide_options():
	$Options.hide()
	
func _show_options():
	$Options.visible = true
	
func _on_move_pressed():
	_enable_edit_mode()
	_hide_options()

func _on_upgrade_pressed():
	_upgrade_level()
	
func follow_cursor_with_snapping():
	.follow_cursor_with_snapping()
	
	var moveability = check_moveability()
	
	if moveability != is_moveable:
		_set_is_moveable(moveability)

func check_moveability():
	return not (get_overlapping_areas().size() > 0 or position.x < boundaries.position.x or position.x > boundaries.end.x or position.y < boundaries.position.y or position.y > boundaries.end.y)
