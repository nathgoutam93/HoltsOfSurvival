extends PopupPanel

signal upgrade_confirm

var _class : int
var level_to_upgrade : int

func _ready():
	popup()
	connect("popup_hide", self, "_on_popup_hide")
	$Control/VBoxContainer/HBoxContainer/VBoxContainer/icon.texture = load(Constants.Buildings[_class][level_to_upgrade].sprites.idle)
	$Control/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer/upgrade_time.text = "{time} sec".format({"time": Constants.Buildings[_class][level_to_upgrade].build_time})
	$Control/VBoxContainer/HBoxContainer/stats/name.text = "{name} (level {level})".format({"name": Constants.Buildings[_class].name,"level": level_to_upgrade})
	$Control/VBoxContainer/HBoxContainer2/upgrade_button.icon = load("res://assets/sprites/icons/{resource}.png".format({"resource": Constants.Buildings[_class][level_to_upgrade].cost.resource}))
	$Control/VBoxContainer/HBoxContainer2/upgrade_button.text = str(Constants.Buildings[_class][level_to_upgrade].cost.amount)
	$Control/VBoxContainer/HBoxContainer2/upgrade_button.connect("pressed", self, "on_upgrade")

func _on_popup_hide():
	GameManager.game.selected_building.show_options()
	queue_free()

func on_upgrade():
	emit_signal("upgrade_confirm")
