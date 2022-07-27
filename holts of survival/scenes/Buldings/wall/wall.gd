extends "res://scenes/Buldings/base_building/base_building.gd"

var adj_walls = {
	"top": null,
	"bottom": null,
	"left": null,
	"right": null
}

func _ready():
	add_to_group("walls")
	if is_selectable:
		_set_adj_walls()

func _enable_edit_mode():
	._enable_edit_mode()
	if is_selectable:
		_reset_adj_walls()

func _edit_complete():
	._edit_complete()
	if is_selectable:
		_set_adj_walls()

func _edit_cancle():
	._edit_cancle()
	_set_adj_walls()
	
func _enable_rays(value: bool):
	$ray_top.set_enabled(value)
	$ray_right.set_enabled(value)
	$ray_left.set_enabled(value)
	$ray_bottom.set_enabled(value)

func _set_sprite():
	
	if adj_walls.left && adj_walls.bottom:
		$Sprite.texture = load(Constants.Buildings[Constants.Building.WALL][_level].sprites.left_bottom)
	elif adj_walls.left:
		$Sprite.texture = load(Constants.Buildings[Constants.Building.WALL][_level].sprites.left)
	elif adj_walls.bottom:
		$Sprite.texture = load(Constants.Buildings[Constants.Building.WALL][_level].sprites.bottom)
	else:
		$Sprite.texture = load(Constants.Buildings[Constants.Building.WALL][_level].sprites.idle)

func _set_adj_walls():
	_enable_rays(true)
	
	yield(get_tree().create_timer(0.1),"timeout")
	
	adj_walls.top = cast($ray_top)
	adj_walls.right = cast($ray_right)
	adj_walls.left = cast($ray_left)
	adj_walls.bottom = cast($ray_bottom)

	if adj_walls.top:
		adj_walls.top.adj_walls.bottom = self
		adj_walls.top._set_sprite()
	if adj_walls.right:
		adj_walls.right.adj_walls.left = self
		adj_walls.right._set_sprite()
	if adj_walls.left:
		adj_walls.left.adj_walls.right = self
	if adj_walls.bottom:
		adj_walls.bottom.adj_walls.top = self
	
	_set_sprite()
	_enable_rays(false)

func _reset_adj_walls():
	if adj_walls.top:
		adj_walls.top.adj_walls.bottom = null
		adj_walls.top._set_sprite()
		adj_walls.top = null
	if adj_walls.right:
		adj_walls.right.adj_walls.left = null
		adj_walls.right._set_sprite()
		adj_walls.right = null
	if adj_walls.left:
		adj_walls.left.adj_walls.right = null
		adj_walls.left = null
	if adj_walls.bottom:
		adj_walls.bottom.adj_walls.top = null
		adj_walls.bottom = null
	
	_set_sprite()

func cast(ray : RayCast2D):
	if ray.is_colliding() && ray.get_collider().is_in_group("walls"):
		return ray.get_collider()
	else:
		return null
