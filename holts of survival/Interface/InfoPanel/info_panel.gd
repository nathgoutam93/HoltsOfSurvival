extends PopupPanel

var _class : int
var _level : int

var label24 = preload("res://Interface/CustomNodes/label_24.tscn")

func _ready():
	popup()
	connect("popup_hide", self, "_on_popup_hide")
	$Control/VBoxContainer/HBoxContainer/icon.texture = load(Constants.Buildings[_class][_level].sprites.idle)
	$Control/VBoxContainer/HBoxContainer/info/name.text = "{name} (level {level})".format({"name": Constants.Buildings[_class].name,"level": _level})
	$Control/VBoxContainer/description.text = Constants.Buildings[_class].description

	if Constants.Buildings[_class][_level].has("hitpoint"):
		var label = label24.instance()
		label.text = "Hitpoints : {hitpoint}".format({"hitpoint": Constants.Buildings[_class][_level].hitpoint})
		$Control/VBoxContainer/HBoxContainer/info/stats.add_child(label)
	
	if Constants.Buildings[_class][_level].has("production"):
		var label = label24.instance()
		label.text = "Production : {value}/hr".format({"value": Constants.Buildings[_class][_level].production})
		$Control/VBoxContainer/HBoxContainer/info/stats.add_child(label)
	
	if Constants.Buildings[_class][_level].has("holdingCapacity"):
		var label = label24.instance()
		label.text = "Holding capacity : {value}".format({"value": Constants.Buildings[_class][_level].holdingCapacity})
		$Control/VBoxContainer/HBoxContainer/info/stats.add_child(label)
	
	if Constants.Buildings[_class][_level].has("capacity"):
		for key in Constants.Buildings[_class][_level].capacity.keys():
			var label = label24.instance()
			label.text = "{resource} capacity : {value}".format({"resource": key, "value": Constants.Buildings[_class][_level].capacity[key]})
			$Control/VBoxContainer/HBoxContainer/info/stats.add_child(label)
		
func _on_popup_hide():
	GameManager.game.selected_building.show_options()
	queue_free()

