extends KinematicBody2D
class_name EnemyBase

enum Temper {HYPERPEACEFUL, PEACEFUL, SEMIPEACEFUL, NEUTRAL, SEMIAGGRESSIVE, AGGRESSIVE, HYPERAGGRESSIVE}
enum Role {PREY, NORMAL, PREDATOR}

var TemperData = {
	Temper.HYPERPEACEFUL: {"min_speed": Global.base_speed},
	Temper.PEACEFUL: {"min_speed": Global.base_speed/1.16},
	Temper.SEMIPEACEFUL: {"min_speed": Global.base_speed/1.33},
	Temper.NEUTRAL: {"min_speed": Global.base_speed/1.5},
	Temper.SEMIAGGRESSIVE: {"min_speed": Global.base_speed/1.66},
	Temper.AGGRESSIVE: {"min_speed": Global.base_speed/1.83},
	Temper.HYPERAGGRESSIVE: {"min_speed": Global.base_speed/2}
}

onready var animation_sprite = $AnimatedSprite
onready var eat_area = $EatArea

export(Role) var role
export(float) var idle_speed_divider = 1.2

var idle_speed: int = 0
var run_speed: int = 0
var temper = 0

var direction = Vector2()

var player
var difficulty_speed: float

var should_vanish: bool = false


func _ready():
	add_to_group("enemies")
	add_to_group("spawnable")
	GameEvents.connect("stop_spawning_spawnable", self, "vanish")
	eat_area.connect("body_entered", self, "on_eatArea_body_entered")
	
	set_temper()


func set_temper():
	if role == Role.PREY:
		var choice = randi()%2
		if choice == 0:
			temper = Temper.HYPERPEACEFUL
		else:
			temper = Temper.PEACEFUL
	
	elif role == Role.NORMAL:
		var choice = randi()%3
		if choice == 0:
			temper = Temper.SEMIPEACEFUL
		elif choice == 1:
			temper = Temper.NEUTRAL
		else:
			temper = Temper.SEMIAGGRESSIVE
	
	elif role == Role.PREDATOR:
		var choice = randi()%2
		if choice == 0:
			temper = Temper.AGGRESSIVE
		else:
			temper = Temper.HYPERAGGRESSIVE


func set_enemy(_player, _scale, _difficulty_speed) -> void:
	player = _player
	difficulty_speed = _difficulty_speed
	scale = Vector2(_scale, _scale)
	
	# setting run and idle speed
	var random_speed = randi()%int(Global.base_speed/2 + difficulty_speed)
	run_speed = TemperData[temper].min_speed + random_speed
	idle_speed = run_speed/idle_speed_divider
	
#	print("Enemy ",role ," temper: ",temper , ", run speed: "\
#	 , str(run_speed), ", idle_speed: ", idle_speed)
	
	# random the rotation
	direction = (player.global_position - global_position).normalized() \
		.rotated(rand_range(-PI / 4, PI / 4))


func _physics_process(delta):
	animation_sprite.global_rotation = direction.angle()
	
	if should_vanish:
		modulate.a -= 1.0*delta
		if modulate.a <= 0.1:
			queue_free()
	
	if global_position.distance_to(player.global_position) > Global.range_limit:
		destroy()
	
	var _vel = move_and_slide(direction * idle_speed)


func on_eatArea_body_entered(body: Node):
	if body.has_method("get_scale"):
		var body_scale = body.get_scale()
		if body_scale <= scale.x - Global.eat_limit:
			if scale.x < 2.0:
				scale += Vector2(0.1, 0.1)
			body.destroy()
	else:
		Global.show_error("res://gameplay/enemies/enemy_base/EnemyBase.gd", "Body don't have method: "+body.name)


func scale_it(amount: float) -> void:
	if scale.x + amount < 0.1: scale = Vector2(0.1, 0.1)
	else: scale += Vector2(amount, amount)
	
	idle_speed *=(1+amount)
	if idle_speed < 50: idle_speed = 50
	
	# scale also ten run speed
	
	#when scaling up
	if amount > 0: amount = amount + amount
	
	var dir = (player.global_position - global_position)*amount
	global_position -= dir


func get_scale():
	return scale.x


func destroy():
	queue_free()


func vanish():
	should_vanish = true
