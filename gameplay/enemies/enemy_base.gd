extends KinematicBody2D
class_name EnemyBase

export(int) var speed = 100

var direction = Vector2()
var player: Player

var should_vanish: bool = false

func _ready():
	add_to_group("enemies")
	add_to_group("spawnable")
	GameEvents.connect("stop_spawning_spawnable", self, "vanish")


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
	
	var _vel = move_and_slide(direction * speed)


func scale_it(amount: float) -> void:
	if scale.x + amount < 0.1: scale = Vector2(0.1, 0.1)
	else: scale += Vector2(amount, amount)
	
	speed *=(1+amount)
	if speed < 50: speed = 50
	#when scaling up
	if amount > 0: amount = amount + amount
	
	var dir = (player.global_position - global_position)*amount
	global_position -= dir


func destroy():
	queue_free()


func vanish():
	should_vanish = true
