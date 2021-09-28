extends KinematicBody2D
class_name Player

onready var eat_area = $EatArea

var joystick: Joystick = null

var direction := Vector2()

export(int) var speed = 100
var size = 0
export(float) var eating_speed = 0.5

var food_multiplier = 0

func _ready():
	GameEvents.connect("force_player_grow_up", self, "grow_up")
	eat_area.connect("body_entered", self, "on_eatArea_body_entered")
	calc_food_multiplier()


func calc_food_multiplier():
	food_multiplier = (Global.size_division/10) * eating_speed


func _physics_process(delta):
	if joystick != null:
		direction = joystick.get_movement()
	else:
		Global.show_error("res://entities/player/Player.gd", "Joystick is NULL")
	
	$DirectionJoint.global_rotation = direction.angle()
	
	var _vel = move_and_slide(direction * speed)


func on_eatArea_body_entered(body: Node):
	if body.has_method("get_scale"):
		if can_eat(body.get_scale()):
			grow_up(body.get_scale())
			body.destroy()
	else:
		Global.show_error("res://gameplay/player/Player.gd", "Body don't have method: "+body.name)


# food_scale - from 0.1 to 0.9, the real scale of thing that was eaten
func grow_up(food_scale):
	var added_size = food_scale * food_multiplier
	var scale_amount = added_size/Global.size_division
	size += added_size
	# every other object should scale down
	get_tree().call_group("spawnable", "scale_it", -scale_amount)
	
	# emit information
	GameEvents.emit_signal("player_grew_up", size, scale_amount)


func can_eat(body_scale) -> bool:
	if body_scale <= scale.x - Global.eat_limit:
		return true
	else:
		return false


func on_load(save: AlaGameSave):
	size = save.player_size


func get_scale():
	return scale.x


func destroy():
	ScenesHandler.switch_scene(ScenesHandler.MENU)
