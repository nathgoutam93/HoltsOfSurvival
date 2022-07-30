extends VBoxContainer

func _ready():
	pass
	
func _exit_tree():
	queue_free()
