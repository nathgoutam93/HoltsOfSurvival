extends PopupPanel

var _class : int
var _level : int

func _ready():
	popup()
	connect("popup_hide", self, "_on_popup_hide")
	$Control/VBoxContainer/HBoxContainer/icon.texture = load(Constants.Buildings[_class][_level].sprites.idle)
	$Control/VBoxContainer/HBoxContainer/stats/name.text = "{name} (level {level})".format({"name": Constants.Buildings[_class].name,"level": _level})

func _on_popup_hide():
	GameManager.game.selected_building.show_options()
	queue_free()

