extends KinematicBody2D
class_name EnemyBase

enum Temper {HYPERPEACEFUL, PEACEFUL, SEMIPEACEFUL, NEUTRAL, SEMIAGGRESSIVE, AGGRESSIVE, HYPERAGGRESSIVE}
enum Role {PREY, NORMAL, PREDATOR}

export(Role) var role

var idle_speed = 100
var run_speed = 100
var temper

var direction = Vector2()
var player
var should_vanish: bool = false

func _ready():
	add_to_group("enemies")
	add_to_group("spawnable")
	GameEvents.connect("stop_spawning_spawnable", self, "vanish")
	
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
			temper = Temper.PEACEFUL
		else:
			temper = Temper.SEMIAGGRESSIVE
	
	elif role == Role.PREDATOR:
		var choice = randi()%2
		if choice == 0:
			temper = Temper.HYPERPEACEFUL
		else:
			temper = Temper.PEACEFUL


func set_enemy(_player) -> void:
	player = _player
	
	direction = (player.global_position - global_position).normalized() \
		.rotated(rand_range(-PI / 4, PI / 4))


func _physics_process(delta):
	if should_vanish:
		modulate.a -= 1.0*delta
		if modulate.a <= 0.1:
			queue_free()
	
	if global_position.distance_to(player.global_position) > Global.range_limit:
		destroy()
	
	var _vel = move_and_slide(direction * idle_speed)


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


func destroy():
	queue_free()


func vanish():
	should_vanish = true
