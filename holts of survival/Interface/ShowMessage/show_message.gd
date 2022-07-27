extends Label

var message : String = "" setget set_message

func _ready():
	yield(get_tree().create_timer(2),"timeout")
	GameManager.hud.remove_child(self)
	queue_free()
	
func set_message(value: String):
	message = value
	text = message
	
