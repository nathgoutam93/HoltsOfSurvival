extends CanvasLayer

signal info
signal upgrade

func _ready():
	$Options/info.connect("pressed", self, "_on_info_pressed")
	$Options/upgrade.connect("pressed", self, "_on_upgrade_pressed")
	$AnimationPlayer.play("pop_in")

func _on_info_pressed():
	emit_signal("info")
	
func _on_upgrade_pressed():
	emit_signal("upgrade")

func _hide_option():
	$AnimationPlayer.play_backwards("pop_in")
	yield(get_tree().create_timer($AnimationPlayer.current_animation_length),"timeout")
	queue_free()
