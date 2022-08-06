extends CanvasLayer

func _ready():
	GameManager.hud = self
	$shop_button.connect("pressed", self, "_open_shop")
	$help_button.connect("pressed", self, "_on_help")

func _on_wood_change():
	$resources/gold_counter._set_amount(GameManager.player._get_wood())

func _on_stone_change():
	$resources/oil_counter._set_amount(GameManager.player._get_stone())

func _set_counters():
	$resources/gold_counter._set_capacity(GameManager.player._total_wood_capacity())
	$resources/oil_counter._set_capacity(GameManager.player._total_stone_capacity())
	$resources/gold_counter._set_amount(GameManager.player._get_wood())
	$resources/oil_counter._set_amount(GameManager.player._get_stone())

func _on_help():
	$HelperPanel.popup()

func _open_shop():
	GameManager.game.selected_building && GameManager.game._set_selected_building(null)
	$shop.popup()
