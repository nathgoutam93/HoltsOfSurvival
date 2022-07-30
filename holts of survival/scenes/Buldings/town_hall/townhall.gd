extends "res://scenes/Buldings/base_building/base_building.gd"

func _ready():
	pass

func upgrade_level():
	var level_to_upgrade = _level + 1
	if not Constants.Buildings[_class].has(level_to_upgrade):
		var message_label = MessageLabel.instance()
		message_label.set_message("Noting to upgrade")
		GameManager.hud.add_child(message_label)
	else:
		var upgrade_cost = Constants.Buildings[_class][level_to_upgrade].cost
		var success = deduct_resource(upgrade_cost.resource, upgrade_cost.amount)
		
		if success:
			_upgrade.status = true
			_upgrade.start = TimeManager.get_time()
			_upgrade.end = _upgrade.start + Constants.Buildings[_class][level_to_upgrade].build_time
	
			add_upgrade_label()

func update_level():
	.update_level()
	GameManager.player.townhall = _level

func upgrade_complete():
	.upgrade_complete()
	GameManager.hud._set_counters()
