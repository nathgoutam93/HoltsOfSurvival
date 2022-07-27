extends CanvasLayer

func _ready():
	GameManager.hud = self
	$shop_button.connect("pressed", self, "_open_shop")

func _process(delta):
	$Label.text = "FPS: " + String(Engine.get_frames_per_second())

func _on_gold_change():
	$resources/gold_counter._set_amount(GameManager.player._get_gold())

func _on_oil_change():
	$resources/oil_counter._set_amount(GameManager.player._get_oil())

func _set_counters():
	$resources/gold_counter._set_capacity(GameManager.player._total_gold_capacity())
	$resources/oil_couter._set_capacity(GameManager.player._total_oil_capacity())
	$resources/gold_counter._set_amount(GameManager.player._get_gold())
	$resources/oil_couter._set_amount(GameManager.player._get_oil())

func _open_shop():
	$shop.popup()
 
