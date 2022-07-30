extends PopupPanel

var ShopButton = preload("res://Interface/Shop/ShopButton/shop_button.tscn")

func _ready():
	connect("about_to_show", self, "_set_shop")
	$Control/HBoxContainer/close_shop.connect("pressed", self, "_hide")

func _set_shop():
	_reset_shop()
	for building in Constants.Buildings.keys():
		if building != Constants.Building.TOWN_HALL:
			var button = ShopButton.instance()
			button._class = building
			button.get_node("VBoxContainer/building_icon").texture = load(Constants.Buildings[building].icon)
			button.get_node("VBoxContainer/building_name").text = Constants.Buildings[building].name
			button.connect("bought", self, "_hide")
			$Control/VBoxContainer/HScrollBar/HBoxContainer.add_child(button)

func _reset_shop():
	for children in $Control/VBoxContainer/HScrollBar/HBoxContainer.get_children():
		children.queue_free()

func _hide():
	hide()
