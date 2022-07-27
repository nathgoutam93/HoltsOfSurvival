extends HBoxContainer

func _ready():
	$buy_cancle.connect("pressed", self, "on_buy_cancle")
	$buy_complete.connect("pressed", self, "on_buy_complete")

func on_buy_cancle():
	GameManager.player.buildings.erase(get_parent()._id)
	get_parent().queue_free()

func on_buy_complete():
	if not get_parent().is_moveable:
		on_buy_cancle()
	else:
		var resource_type = Constants.Buildings[get_parent()._class][Constants.Level_1].cost.resource
		var building_cost = Constants.Buildings[get_parent()._class][Constants.Level_1].cost.amount
		var success = get_parent().deduct_resource(resource_type, building_cost)
		if success:
			GameManager.game.remove_child(get_parent())
			GameManager.game.get_node("YSort").add_child(get_parent())
			get_parent()._set_selectable(true)
			get_parent().is_in_group("walls") && get_parent()._set_adj_walls()
			queue_free()
		else:
			on_buy_cancle()
