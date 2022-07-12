extends KinematicBody2D
class_name EnemyBase

enum Temper {HYPERPEACEFUL, PEACEFUL, SEMIPEACEFUL, NEUTRAL, SEMIAGGRESSIVE, AGGRESSIVE, HYPERAGGRESSIVE}
enum Role {PREY, NORMAL, PREDATOR}

var TemperData = {
	Temper.HYPERPEACEFUL: {"min_speed": Global.base_speed, "atta_prob": 0.0, "flee_prob": 0.5},
	Temper.PEACEFUL: {"min_speed": Global.base_speed/1.16, "atta_prob": 0.08, "flee_prob": 0.41},
	Temper.SEMIPEACEFUL: {"min_speed": Global.base_speed/1.33, "atta_prob": 0.16, "flee_prob": 0.33},
	Temper.NEUTRAL: {"min_speed": Global.base_speed/1.5, "atta_prob": 0.25, "flee_prob": 0.25},
	Temper.SEMIAGGRESSIVE: {"min_speed": Global.base_speed/1.66, "atta_prob": 0.33, "flee_prob": 0.16},
	Temper.AGGRESSIVE: {"min_speed": Global.base_speed/1.83, "atta_prob": 0.41, "flee_prob": 0.08},
	Temper.HYPERAGGRESSIVE: {"min_speed": Global.base_speed/2, "atta_prob": 0.5, "flee_prob": 0.0}
}

onready var animation_sprite = $AnimatedSprite
onready var eat_area = $EatArea
onready var ai = $AI
onready var destroy_particles = $StandardDestroyParticles

export(Role) var role
export(float) var idle_speed_divider = 1.2

var idle_speed: int = 0
var run_speed: int = 0
var temper = 0
var push_force: Vector2 = Vector2.ZERO

var direction = Vector2()

var player
var difficulty_speed: float

var should_vanish: bool = false
var should_destroy: bool = false

# for ai
var ai_target = null
var ai_action = Global.AI_Action.MOVING


func _ready():
	add_to_group("enemies")
	add_to_group("spawnable")
	GameEvents.connect("stop_spawning_spawnable", self, "vanish")
	eat_area.connect("body_entered", self, "on_eatArea_body_entered")
	ai.connect("attack", self, "attack_ai")
	ai.connect("flee", self, "flee_ai")
	ai.connect("move", self, "move_ai")
	
	set_temper()
	ai.set_priority(AI.AI_FLEE, AI.AI_ATTACK, AI.AI_MOVE)


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


func set_enemy(_player, _scale, _difficulty_speed, _difficulty_ai_time, _difficulty_ai_prob) -> void:
	player = _player
	difficulty_speed = _difficulty_speed
	scale = Vector2(_scale, _scale)
	
	if scale.x <= 1.0 - Global.eat_limit:
		add_to_group("attackable")
	else:
		add_to_group("avoidable")
	
	# setting run and idle speed
	var random_speed = randi()%int(Global.base_speed/2 + difficulty_speed)
	run_speed = TemperData[temper].min_speed + random_speed
	idle_speed = run_speed/idle_speed_divider
	
	# setting ai
	ai.set_probality(TemperData[temper].atta_prob + _difficulty_ai_prob\
		, TemperData[temper].flee_prob + _difficulty_ai_prob)
	ai.set_action_time(_difficulty_ai_time)
	ai.start_ai()
	
#	print("Enemy ",role ," temper: ",temper , ", run speed: "\
#	 , str(run_speed), ", idle_speed: ", idle_speed)
	
	# random the rotation
	direction = (player.global_position - global_position).normalized() \
		.rotated(rand_range(-PI / 4, PI / 4))


func _physics_process(delta):
	if should_vanish:
		modulate.a -= 1.0*delta
		if modulate.a <= 0.1:
			queue_free()
	
	if should_destroy and destroy_particles.emitting == false:
		queue_free()
	
	
	if abs(player.global_position.x - global_position.x) > Global.range_spawn.x + 10:
		destroy()
	if abs(player.global_position.y - global_position.y) > Global.range_spawn.y + 10:
		destroy()
	
	if ai_action == Global.AI_Action.ATTACKING and is_instance_valid(ai_target):
		var new_dir = (ai_target.global_position-global_position).normalized()
		animation_sprite.global_rotation = new_dir.angle()
		var _vel = move_and_slide((new_dir * run_speed) + push_force)
		
	elif ai_action == Global.AI_Action.FLEEING and is_instance_valid(ai_target):
		var new_dir = (global_position-ai_target.global_position).normalized()
		animation_sprite.global_rotation = new_dir.angle()
		var _vel = move_and_slide((new_dir * run_speed) + push_force)
		
	else:
		animation_sprite.global_rotation = direction.angle()
		var _vel = move_and_slide((direction * idle_speed) + push_force)
	
	# reduce slowly push_force
	if push_force != Vector2.ZERO:
		push_force /= 1.5
		if push_force.x < 1 and push_force.y < 1:
			push_force = Vector2.ZERO


func on_eatArea_body_entered(body: Node):
	if body.has_method("get_scale"):
		if can_eat(body.get_scale()):
			if scale.x < 2.0:
				scale += Vector2(0.1, 0.1)
			body.destroy()
	else:
		Global.show_error("res://gameplay/enemies/enemy_base/EnemyBase.gd", "Body don't have method: "+body.name)


func can_eat(body_scale) -> bool:
	if body_scale <= scale.x - Global.eat_limit:
		return true
	else:
		return false


func scale_it(amount: float) -> void:
	if scale.x + amount < 0.1: scale = Vector2(0.1, 0.1)
	else: scale += Vector2(amount, amount)
	
	idle_speed *=(1+amount)
	if idle_speed < 50: idle_speed = 50
	
	# scale also ten run speed
	
	#when scaling up
	if amount > 0: amount = amount + amount
	
	if scale.x <= 1.0 - Global.eat_limit:
		add_to_group("attackable")
		if self.is_in_group("avoidable"):
			remove_from_group("avoidable")
	else:
		add_to_group("avoidable")
		if self.is_in_group("attackable"):
			remove_from_group("attackable")
	
	var dir = (player.global_position - global_position)*amount
	global_position -= dir


func attack_ai(body):
	animation_sprite.play("run")
	ai_action = Global.AI_Action.ATTACKING
	ai_target = body


func flee_ai(body):
	animation_sprite.play("run")
	ai_action = Global.AI_Action.FLEEING
	ai_target = body


func move_ai():
	animation_sprite.play("idle")
	ai_action = Global.AI_Action.MOVING


func get_scale():
	return scale.x


func destroy():
	destroy_particles.emitting = true
	animation_sprite.hide()
	should_destroy = true


func vanish():
	should_vanish = true


func push(force):
	push_force = force
