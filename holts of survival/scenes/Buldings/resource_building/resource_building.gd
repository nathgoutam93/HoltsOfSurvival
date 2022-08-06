extends "res://scenes/Buldings/base_building/base_building.gd"

enum Resource {
	WOOD,
	STONE
}

export(Resource) var resource_type = Resource.WOOD

onready var _production_rate : float = Constants.Buildings[_class][_level].production / 3600.0
onready var _notify_rate : float = (_production_rate * 3600.0) / 100.0 * 1.0
onready var max_fill =  Constants.Buildings[_class][_level].holdingCapacity as float

onready var _resource = GameManager.player.buildings[_id].resource 

# _resource = {"full": false,"current_fill": 0.0,"last_produced": 0}

func _ready():
	if not _resource.full:
		var seconds_passed = TimeManager.get_time() - _resource.last_produced
		var resource_generated = seconds_passed * _production_rate
		_resource.current_fill = clamp(_resource.current_fill + resource_generated, 0.0, max_fill)
		_resource.last_produced = TimeManager.get_time()
		if _resource.current_fill >= max_fill:
			_resource.full = true
	
	if _resource.current_fill >= _notify_rate:
		$notify.set_visible(true)

	start_producing()

func start_producing():
	var resource_timer = Timer.new()
	var update_timer = Timer.new()
	update_timer.set_wait_time(5.0)
	resource_timer.connect("timeout", self, "produce_resource")
	update_timer.connect("timeout", self, "update_resource")
	add_child(resource_timer)
	add_child(update_timer)
	resource_timer.start()
	update_timer.start()
	
func produce_resource():
	if not _resource.full:
		_resource.current_fill = clamp(_resource.current_fill + _production_rate, 0.0, max_fill)
		_resource.last_produced = TimeManager.get_time()

		if _resource.current_fill >= _notify_rate:
			$notify.set_visible(true)
		
		if _resource.current_fill >= max_fill:
			_resource.full = true

func update_resource():
	if GameManager.player.buildings[_id].resource.hash() != _resource.hash():
		GameManager.player.buildings[_id].resource = _resource

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
	if _resource.current_fill > 0:
		match resource_type:
			Resource.WOOD:
				GameManager.player.wood = (GameManager.player._get_wood() + round(_resource.current_fill))
			Resource.STONE:
				GameManager.player.stone = (GameManager.player._get_stone() + round(_resource.current_fill))
		
		reset_status()

func reset_status():
	_resource = {
	"full": false,
	"current_fill": 0.0,
	"last_produced": _resource.last_produced
	}
	start_producing()
	$notify.set_visible(false)
