extends CanvasLayer

signal upgrade

func _ready():
	$Options/upgrade.connect("pressed", self, "_on_upgrade_pressed")

func _on_upgrade_pressed():
	emit_signal("upgrade")

func _hide_option():
	$AnimationPlayer.play_backwards("pop_in")

func _show_option():
	$AnimationPlayer.play("pop_in")
