extends KinematicBody2D
class_name Player


var joystick: Joystick = null

var direction := Vector2()

export(int) var speed = 100


func _ready():
	pass


func _physics_process(delta):
	if joystick != null:
		direction = joystick.get_movement()
	else:
		Global.show_error("res://entities/player/Player.gd", "Joystick is NULL")
	
	var _vel = move_and_slide(direction * speed)
