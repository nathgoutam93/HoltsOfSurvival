extends Camera2D

# Lower cap for the `_zoom_level`.
export var min_zoom := 0.2
# Upper cap for the `_zoom_level`.
export var max_zoom := 0.6
# Controls how much we increase or decrease the `_zoom_level` on every turn of the scroll wheel.
export var zoom_factor := 0.1
# Duration of the zoom's tween animation.
export var zoom_duration := 0.2
# The camera's target zoom level.
var _zoom_level := 1.0 setget _set_zoom_level

# camera speed 
export var camera_speed := 5.0

# We store a reference to the scene's tween node.
onready var tween: Tween = $Tween

func _ready():
	_set_zoom_level(_zoom_level)

func _process(delta):
	var input_vector = get_input_vector()
	move_map_around(input_vector)

func _input(event):
	if event.is_action_pressed("zoom_in"):
		_set_zoom_level(_zoom_level - zoom_factor)
	if event.is_action_pressed("zoom_out"):
		_set_zoom_level(_zoom_level + zoom_factor)	

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input_vector.normalized()

func move_map_around(input_vector):
	var camera_half_size = get_viewport().size * _zoom_level / 2
	self.global_position.x = clamp(self.global_position.x + input_vector.x * camera_speed, self.limit_left + camera_half_size.x, self.limit_right - camera_half_size.x)
	self.global_position.y = clamp(self.global_position.y + input_vector.y * camera_speed, self.limit_top + camera_half_size.y, self.limit_bottom - camera_half_size.y)

func _set_zoom_level(value: float) -> void:
	# We limit the value between `min_zoom` and `max_zoom`
	_zoom_level = clamp(value, min_zoom, max_zoom)
	# Then, we ask the tween node to animate the camera's `zoom` property from its current value
	# to the target zoom level.
	tween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(_zoom_level, _zoom_level),
		zoom_duration,
		tween.TRANS_SINE,
		# Easing out means we start fast and slow down as we reach the target value.
		tween.EASE_OUT
	)
	tween.start()
