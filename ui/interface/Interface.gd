extends Control


onready var joystick = $JoystickAnchor/Joystick
onready var size_label = $HBoxContainer/SizeLabel
onready var time_label = $TimerLabel
onready var pause_button = $HBoxContainer/PauseButton

func _ready():
	GameEvents.connect("player_grew_up", self, "_update_size")
	GameEvents.connect("time_changed", self, "_update_time_label")
	pause_button.connect("pressed", self, "pause_game")
	
	if Global.js_side == Global.JsSides.LEFT:
		time_label.align = Label.ALIGN_RIGHT
	else:
		time_label.align = Label.ALIGN_LEFT


func _update_size(size: int, amount: float):
	size_label.text = "Size: " + str(size)


func _update_time_label(time):
	time_label.text = "Time: " + time


func pause_game():
	GameEvents.emit_signal("show_popup_pause")
