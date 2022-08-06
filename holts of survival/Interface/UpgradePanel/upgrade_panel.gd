extends PopupPanel

signal upgrade_confirm

var label24 = preload("res://Interface/CustomNodes/label_24.tscn")

var _class : int
var level_to_upgrade : int

func _ready():
	popup()
	connect("popup_hide", self, "_on_popup_hide")
	
	$Control/VBoxContainer/HBoxContainer/VBoxContainer/icon.texture = load(Constants.Buildings[_class][level_to_upgrade].sprites.idle)
	$Control/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer/upgrade_time.text = TimeManager.formatSeconds(Constants.Buildings[_class][level_to_upgrade].build_time)
	$Control/VBoxContainer/HBoxContainer/info/name.text = "{name} (level {level})".format({"name": Constants.Buildings[_class].name,"level": level_to_upgrade})
	$Control/VBoxContainer/HBoxContainer2/upgrade_button.icon = load("res://assets/sprites/icons/{resource}_icon_64.png".format({"resource": Constants.Buildings[_class][level_to_upgrade].cost.resource}))
	$Control/VBoxContainer/HBoxContainer2/upgrade_button.text = str(Constants.Buildings[_class][level_to_upgrade].cost.amount)
	$Control/VBoxContainer/HBoxContainer2/upgrade_button.connect("pressed", self, "on_upgrade")

	if Constants.Buildings[_class][level_to_upgrade].has("hitpoint"):
		var current = Constants.Buildings[_class][level_to_upgrade-1].hitpoint
		var increase = Constants.Buildings[_class][level_to_upgrade].hitpoint - current
		
		var label = label24.instance()
		label.text = "Hitpoints : {current} + {add}".format({"current": current, "add": increase})
		$Control/VBoxContainer/HBoxContainer/info/stats.add_child(label)
	
	if Constants.Buildings[_class][level_to_upgrade].has("production"):
		var current = Constants.Buildings[_class][level_to_upgrade-1].production
		var increase = Constants.Buildings[_class][level_to_upgrade].production - current
		
		var label = label24.instance()
		label.text = "Production : {current} + {add}/hr".format({"current": current, "add": increase})
		$Control/VBoxContainer/HBoxContainer/info/stats.add_child(label)
	
	if Constants.Buildings[_class][level_to_upgrade].has("holdingCapacity"):
		var current = Constants.Buildings[_class][level_to_upgrade-1].holdingCapacity
		var increase = Constants.Buildings[_class][level_to_upgrade].holdingCapacity - current
		
		var label = label24.instance()
		label.text = "Holding capacity : {current} + {add}".format({"current": current, "add": increase})
		$Control/VBoxContainer/HBoxContainer/info/stats.add_child(label)
	
	if Constants.Buildings[_class][level_to_upgrade].has("capacity"):
		for key in Constants.Buildings[_class][level_to_upgrade].capacity.keys():
			var current = Constants.Buildings[_class][level_to_upgrade-1].capacity[key]
			var increase = Constants.Buildings[_class][level_to_upgrade].capacity[key] - current
			
			var label = label24.instance()
			label.text = "{resource} capacity : {current} + {add}".format({"resource": key, "current": current, "add": increase})
			$Control/VBoxContainer/HBoxContainer/info/stats.add_child(label)

func _on_popup_hide():
	GameManager.game.selected_building.show_options()
	queue_free()

func on_upgrade():
	emit_signal("upgrade_confirm")
	hide()
