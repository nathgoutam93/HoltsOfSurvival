extends Label

var time_of_upgrade_complete : int

func _ready():
	$Timer.connect("timeout", self, "_on_timeout")
	self.text = str(time_left()) + " sec"

func time_left() -> int:
	return int(time_of_upgrade_complete - TimeManager.get_time())

func _on_timeout():
	self.text = str(time_left()) + " sec"
