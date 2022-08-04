extends KinematicBody2D
class_name Player

onready var eat_area = $EatArea
onready var flee_area = $FleeArea
onready var mutations = $Mutations
onready var skills = $Skills

var joystick: Joystick = null

var direction := Vector2()

export(int) var speed = 100
var whole_speed = 0

var size = 0
export(float) var eating_speed = 0.5

var mutation_speed = 0
var mutation_hunger = 0

var food_multiplier = 0

func _ready():
	add_to_group("player")
	GameEvents.connect("force_player_grow_up", self, "grow_up")
	eat_area.connect("body_entered", self, "on_eatArea_body_entered")
	mutations.connect("mutation_new_speed", self, "_mutation_new_speed")
	mutations.connect("mutation_new_magic", self, "_mutation_new_magic")
	mutations.connect("mutation_new_hunger", self, "_mutation_new_hunger")
	mutations.connect("mutation_new_growth", self, "grow_up_by_points")
	
	skills.flee_area = flee_area
	
	calc_food_multiplier()
	calc_whole_speed()


func calc_food_multiplier():
	food_multiplier = (Global.size_division/10) * eating_speed
	food_multiplier += (mutation_hunger*food_multiplier/100)
	if food_multiplier > 150.0: food_multiplier = 150.0


func calc_whole_speed():
	whole_speed = speed + (mutation_speed*speed/100)
	if whole_speed > 400: whole_speed = 400


func _physics_process(delta):
	if joystick != null:
		direction = joystick.get_movement()
	else:
		Global.show_error("res://entities/player/Player.gd", "Joystick is NULL")
	
	$DirectionJoint.global_rotation = direction.angle()
	
	var _vel = move_and_slide(direction * whole_speed)


func on_eatArea_body_entered(body: Node):
	if body.has_method("get_scale"):
		if can_eat_actuall_eating(body.get_scale()):
			grow_up(body.get_scale())
			body.destroy()
	else:
		Global.show_error("res://gameplay/player/Player.gd", "Body don't have method: "+body.name)


func _mutation_new_speed(_mutation_speed):
	mutation_speed = _mutation_speed
	calc_whole_speed()


func _mutation_new_magic(_mutation_magic):
	skills.mutation_magic_value = _mutation_magic
	skills.set_reload_timers()


func _mutation_new_hunger(_mutation_hunger):
	mutation_hunger = _mutation_hunger
	calc_food_multiplier()


func grow_up_by_points(points):
	var scale_amount = points/Global.size_division as float
	size += points
	# every other object should scale down
	get_tree().call_group("spawnable", "scale_it", -scale_amount)
	# emit information
	GameEvents.emit_signal("player_grew_up", size, scale_amount)


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
	if body_scale <= 1.0 - Global.eat_limit:
		return true
	else:
		return false

func can_eat_actuall_eating(body_scale) -> bool:
	if body_scale <= scale.x - Global.eat_limit:
		return true
	else:
		return false

func on_load(save: AlaGameSave):
	size = save.player_size
	skills.skill_push = save.skill_push
	skills.skill_pull = save.skill_pull
	skills.skill_push_aoe = save.skill_push_aoe
	skills.skill_pull_aoe = save.skill_pull_aoe
	mutations.mutation_speed_number = save.mutation_speed
	mutations.mutation_magic_number = save.mutation_magic
	mutations.mutation_growth_number = save.mutation_growth
	mutations.mutation_hunger_number = save.mutation_hunger
	mutations.on_load()
	skills.on_load()


func get_scale():
	return scale.x


func destroy():
	GameEvents.emit_signal("end_game")
