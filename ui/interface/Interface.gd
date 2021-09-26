extends Control


onready var joystick = $JoystickAnchor/Joystick
onready var size_label = $HBoxContainer/SizeLabel
onready var time_label = $TimerLabel

func _ready():
	GameEvents.connect("player_grew_up", self, "_update_size")
	GameEvents.connect("time_changed", self, "_update_time_label")


func _update_size(size: int, amount: float):
	size_label.text = "Size: " + str(size)


func _update_time_label(time):
	time_label.text = "Time: " + time
