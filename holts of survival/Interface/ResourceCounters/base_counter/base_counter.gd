extends Control

enum resource {
	GOLD,
	OIL,
}

export(resource) var resource_type = resource.GOLD
var amount : int setget _set_amount, _get_amount
var total_capacity : int setget _set_capacity, _get_capacity

func _ready():
	pass

func _set_amount(value : int):
	amount = value
	$amount_label.text = str(amount)
	_set_bar_value()
	
func _get_amount():
	return amount

func _set_capacity(value: int):
	total_capacity = value
	_set_bar_max_value()

func _get_capacity():
	return total_capacity

func _set_bar_max_value():
	$progress_bar.max_value = _get_capacity()
	
func _set_bar_value():
	$progress_bar.value = _get_amount()
