extends Timer

var s : int = 0
var m : int = 0
var h : int = 0

signal time_changed

func _ready():
	connect("timeout", self, "_on_Timer_timeout")
	start()

func get_formated_time() -> String:
	var str_time : String
	var seconds : String = "%02d" % [s]
	var minutes : String = "%02d" % [m]
	var hours : String = str(h)
	
	str_time = hours + ":" + minutes + ":" + seconds
	
	return str_time

func _on_Timer_timeout():
	s += 1
	if s > 59:
		s = 0
		m += 1
	if m > 59:
		m = 0
		h += 1
	
	GameEvents.emit_signal("time_changed", get_formated_time())
