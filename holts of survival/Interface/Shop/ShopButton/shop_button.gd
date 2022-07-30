extends TextureButton


signal bought

var message_label = preload("res://Interface/ShowMessage/show_message.tscn")
var buy_options = preload("res://Interface/Shop/BuyOptions/buy_options.tscn")

var _class : int = 0

func _ready():
	$VBoxContainer/HBoxContainer/cost_amount.text = str(Constants.Buildings[_class][Constants.Level_1].cost.amount)
	$VBoxContainer/building_icon/count.text = str(GameManager.player._get_building_count(_class)) + "/" + str(Constants.Buildings[_class].count[GameManager.player.townhall])
	$VBoxContainer/HBoxContainer/cost_resource.texture = load("res://assets/sprites/icons/{resource}.png".format({"resource": Constants.Buildings[_class][Constants.Level_1].cost.resource}))

func _pressed():
	
	var is_able = is_able_to_buy().is_able
	var reason = is_able_to_buy().reason
	
	if not is_able:
		var message = message_label.instance()
		message.set_message(reason)
		GameManager.hud.add_child(message)
		return
		
	var _id = Uuid.v4()
	var building = {
		"id": _id,
		"class" : _class,
		"level" : 1,
		"pos" : {
			"x": GameManager.game.get_node("Camera2D").position.x,
			"y": GameManager.game.get_node("Camera2D").position.y
		},
		"upgrade": {
			"status": false,
			"start": 0,
			"end": 0
		}
	}
	var b_instance = GameManager.game._spawn_building(building)
	GameManager.game.add_child(b_instance)
	b_instance._set_is_moveable(b_instance.check_moveability())
	GameManager.player.buildings[_id] = building
	var buy_option_instance = buy_options.instance()
	b_instance.add_child(buy_option_instance)
	emit_signal("bought")

func is_able_to_buy() -> Dictionary:
	var is_able = true
	var reason = ""
	
	if Constants.Buildings[_class].count[GameManager.player.townhall] == 0:
		is_able = false
		reason = "Not Unlocked"
	elif not GameManager.player._get_building_count(_class) < Constants.Buildings[_class].count[GameManager.player.townhall]:
		is_able = false
		reason = "Built maximum numbers allowed"
	
	return {
		"is_able": is_able,
		"reason": reason
	}
	
