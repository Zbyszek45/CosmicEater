extends "res://ui/popups/popup_base_accept/PopupBaseAccept.gd"


onready var joystick_left = $MargCont/Vbox/Content/Joystick/LeftButton
onready var joystick_right = $MargCont/Vbox/Content/Joystick/RightButton

onready var joystick_small = $MargCont/Vbox/Content/JoystickSize/SmallButton
onready var joystick_medium = $MargCont/Vbox/Content/JoystickSize/MediumButton
onready var joystick_big = $MargCont/Vbox/Content/JoystickSize/BigButton
onready var joystick_huge = $MargCont/Vbox/Content/JoystickSize/HugeButton


func _ready():
	joystick_left.connect("pressed", self, "_on_joystick_left_pressed")
	joystick_right.connect("pressed", self, "_on_joystick_right_pressed")
	joystick_small.connect("pressed", self, "_on_joystick_size_pressed", [Global.JsSizes.SMALL])
	joystick_medium.connect("pressed", self, "_on_joystick_size_pressed", [Global.JsSizes.MEDIUM])
	joystick_big.connect("pressed", self, "_on_joystick_size_pressed", [Global.JsSizes.BIG])
	joystick_huge.connect("pressed", self, "_on_joystick_size_pressed", [Global.JsSizes.HUGE])
	set_allign_colors()
	set_size_colors()


func _on_joystick_left_pressed():
	Global.js_side = Global.JsSides.LEFT
	set_allign_colors()


func _on_joystick_right_pressed():
	Global.js_side = Global.JsSides.RIGHT
	set_allign_colors()


func set_allign_colors():
	if Global.js_side == Global.JsSides.LEFT:
		joystick_left.modulate = Color(0, 0, 1, 1)
		joystick_right.modulate = Color(1, 1, 1, 1)
	else:
		joystick_right.modulate = Color(0, 0, 1, 1)
		joystick_left.modulate = Color(1, 1, 1, 1)


func _on_joystick_size_pressed(size):
	if size == Global.JsSizes.SMALL:
		Global.js_size = Global.JsSizes.SMALL
	elif size == Global.JsSizes.MEDIUM:
		Global.js_size = Global.JsSizes.MEDIUM
	elif size == Global.JsSizes.BIG:
		Global.js_size = Global.JsSizes.BIG
	elif size == Global.JsSizes.HUGE:
		Global.js_size = Global.JsSizes.HUGE
	
	set_size_colors()


func set_size_colors():
	if Global.js_size == Global.JsSizes.SMALL:
		joystick_small.modulate = Color(0, 0, 1, 1)
		joystick_medium.modulate = Color(1, 1, 1, 1)
		joystick_big.modulate = Color(1, 1, 1, 1)
		joystick_huge.modulate = Color(1, 1, 1, 1)
	elif Global.js_size == Global.JsSizes.MEDIUM:
		joystick_small.modulate = Color(1, 1, 1, 1)
		joystick_medium.modulate = Color(0, 0, 1, 1)
		joystick_big.modulate = Color(1, 1, 1, 1)
		joystick_huge.modulate = Color(1, 1, 1, 1)
	elif Global.js_size == Global.JsSizes.BIG:
		joystick_small.modulate = Color(1, 1, 1, 1)
		joystick_medium.modulate = Color(1, 1, 1, 1)
		joystick_big.modulate = Color(0, 0, 1, 1)
		joystick_huge.modulate = Color(1, 1, 1, 1)
	elif Global.js_size == Global.JsSizes.HUGE:
		joystick_small.modulate = Color(1, 1, 1, 1)
		joystick_medium.modulate = Color(1, 1, 1, 1)
		joystick_big.modulate = Color(1, 1, 1, 1)
		joystick_huge.modulate = Color(0, 0, 1, 1)


func _on_accept():
	print("saving settings")
	Global.save_settings()
