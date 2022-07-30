extends "res://scenes/Buldings/base_building/base_building.gd"

enum Resource {
	WOOD,
	STONE
}

export(Resource) var resource_type = Resource.WOOD

onready var resource_timer = $Timer

onready var _production_rate : float = Constants.Buildings[_class][_level].production / 3600.0
onready var _notify_rate : float = (_production_rate * 3600.0) / 100.0 * 1.0

onready var status = {
	"full": false,
	"current_fill": 0.0,
	"max_fill": Constants.Buildings[_class][_level].capacity as float
}

func _ready():
	start_producing()

func start_producing():
	resource_timer.connect("timeout", self, "produce_resource")
	resource_timer.start()
	
func produce_resource():
	if not status.full:
		status.current_fill = clamp(status.current_fill + _production_rate, 0.0, status.max_fill)
		if status.current_fill >= status.max_fill:
			status.full = true
		elif status.current_fill >= _notify_rate:
			$notify.set_visible(true)

func add_options():
	var building_options = Options.instance()
	building_options.connect("info", self, "_on_info_panel")
	building_options.connect("upgrade", self, "_on_upgrade_panel")
	building_options.connect("collect", self, "_on_collect_resource")
	add_child(building_options)

func remove_options():
	get_node("Options").disconnect("info", self, "_on_info_panel")
	get_node("Options").disconnect("upgrade", self, "_on_upgrade_panel")
	get_node("Options").disconnect("collect", self, "_on_collect_resource")
	get_node("Options").has_method("_hide_option") && get_node("Options")._hide_option()

func _on_collect_resource():
	if status.current_fill > 0:
		match resource_type:
			Resource.WOOD:
				GameManager.player.wood = (GameManager.player._get_wood() + round(status.current_fill))
			Resource.STONE:
				GameManager.player.stone = (GameManager.player._get_stone() + round(status.current_fill))
		
		reset_status()

func reset_status():
	status = {
	"full": false,
	"current_fill": 0.0,
	"max_fill": Constants.Buildings[_class][_level].capacity as float
	}
	$notify.set_visible(false)
