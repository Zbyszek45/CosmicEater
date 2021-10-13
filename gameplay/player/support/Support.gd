extends AnimatedSprite

onready var area = $Area

var bodies = []

enum {ATTACKING, FEEDING}

var state = ATTACKING

var attack_area: Area2D
var player setget set_player
var food_scale = 0

func _ready():
	add_to_group("support")
	area.connect("body_entered", self, "on_Area_body_entered")
	attack_area.connect("body_entered", self, "on_body_AttackArea_entered")
	attack_area.connect("body_exited", self, "on_body_AttackArea_exited")


func set_support(skill):
	scale.x = 0.4 + (skill * 0.01)
	scale.y = 0.4 + (skill * 0.01)
	state = ATTACKING


func _physics_process(delta):
	if abs(player.global_position.x - global_position.x) > Global.range_spawn.x + 10:
		global_position = player.global_position
	if abs(player.global_position.y - global_position.y) > Global.range_spawn.y + 10:
		global_position = player.global_position
	
	if state == ATTACKING and bodies.size() > 0:
		var direction = bodies[0].global_position - global_position
		global_position += direction.normalized() * (player.whole_speed * 1.5)  * delta
	elif state == FEEDING:
		var direction = player.global_position - global_position
		global_position += direction.normalized() * (player.whole_speed * 1.5)  * delta
	else:
		var direction: Vector2 = player.global_position - global_position + Vector2(100, 100)
		if direction.length() > 60:
			global_position += direction.normalized() * (player.whole_speed * 1.5)  * delta
	
	for i in area.get_overlapping_bodies():
		if state == FEEDING:
			if i.is_in_group("player"):
				i.grow_up(food_scale)
				state = ATTACKING


func on_Area_body_entered(body: Node):
	if body.is_in_group("enemies"):
		if body.has_method("get_scale"):
			if can_eat(body.get_scale()):
				food_scale = body.get_scale()
				body.destroy()
				state = FEEDING
		else:
			Global.show_error("res://gameplay/player/support/Support.gd", "Body don't have method: "+body.name)


func on_body_AttackArea_entered(body: Node):
	if body.has_method("get_scale") and body.is_in_group("enemies"):
		if can_eat(body.get_scale()):
			bodies.append(body)
	else:
		Global.show_error("res://gameplay/player/support/Support.gd", "Body don't have method: "+body.name)


func on_body_AttackArea_exited(body: Node):
	bodies.erase(body)


func can_eat(body_scale) -> bool:
	if body_scale <= scale.x - Global.eat_limit:
		return true
	else:
		return false


func set_player(_player):
	player = _player
	attack_area = player.attack_area
