extends Node

var speed = 1.0

var time = OS.get_unix_time() setget set_time, get_time

func _ready():
	pass

func _process(delta):
	time += delta * speed

func set_time(value : int):
	time = value
	
func get_time():
	return floor(time)

func formatSeconds(seconds) -> String:
	var day = 86400;
	var hour = 3600;
	var minute = 60;

	var daysout = floor(seconds / day);
	var hoursout = floor((seconds - daysout * day)/hour);
	var minutesout = floor((seconds - daysout * day - hoursout * hour)/minute);
	var secondsout = seconds - daysout * day - hoursout * hour - minutesout * minute;
	
	var formatedSeconds = {
		"day": daysout,
		"hour": hoursout,
		"minute": minutesout,
		"second": secondsout,
	}
	
	var formated_string = ""
	if formatedSeconds.day > 0:
		formated_string += "{day} d ".format({"day": formatedSeconds.day })
	if formatedSeconds.hour > 0:
		formated_string += "{hour} h ".format({"hour": formatedSeconds.hour})
	if formatedSeconds.minute > 0:
		formated_string += "{minute} m ".format({"minute": formatedSeconds.minute}) 
	if formatedSeconds.second > 0:
		formated_string += "{second} s".format({"second": formatedSeconds.second})
	return formated_string
