extends HBoxContainer

signal move
signal upgrade

func _ready():
	$move.connect("pressed", self, "_on_move_pressed")
	$upgrade.connect("pressed", self, "_on_upgrade_pressed")

func _on_move_pressed():
	emit_signal("move")

func _on_upgrade_pressed():
	emit_signal("upgrade")

func _hide_option():
	self.hide()

func _show_option():
	self.visible = true
