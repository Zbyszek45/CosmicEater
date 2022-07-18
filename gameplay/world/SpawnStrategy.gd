extends Node

var enemy_bouncy = preload("res://gameplay/enemies/enemy_bouncy/EnemyBouncy.tscn")
var enemy_mouthy = preload("res://gameplay/enemies/enemy_mouthy/EnemyMouthy.tscn")
var enemy_spiky = preload("res://gameplay/enemies/enemy_spiky/EnemySpiky.tscn")
var enemy_wavy = preload("res://gameplay/enemies/enemy_wavy/EnemyWavy.tscn")
var enemy_tentacy = preload("res://gameplay/enemies/enemy_tentacy/EnemyTentacy.tscn")
var enemy_bouncy_v2 = preload("res://gameplay/enemies/enemy_bouncyv2/EnemyBouncyV2.tscn")
var enemy_mouthy_v2 = preload("res://gameplay/enemies/enemy_mouthyv2/EnemyMouthyV2.tscn")
var enemy_spiky_v2 = preload("res://gameplay/enemies/enemy_spikyv2/EnemySpikyV2.tscn")
var enemy_wavy_v2 = preload("res://gameplay/enemies/enemy_wavyv2/EnemyWavyV2.tscn")
var enemy_tentacy_v2 = preload("res://gameplay/enemies/enemy_tentacyv2/EnemyTentacyV2.tscn")

var enemies = [
	enemy_bouncy,
	enemy_wavy,
	enemy_spiky,
	enemy_tentacy,
	enemy_mouthy,
	enemy_bouncy_v2,
	enemy_wavy_v2,
	enemy_spiky_v2,
	enemy_tentacy_v2,
	enemy_mouthy_v2
]

var decoration = preload("res://gameplay/decorations/Decoration.tscn")

var event_mutation = preload("res://gameplay/events/event_mutation/EventMutation.tscn")
var event_skill = preload("res://gameplay/events/event_skill/EventSkill.tscn")

var events = [
	event_mutation,
	event_skill
]

onready var enemy_spawn_timer = $EnemySpawnTimer

export(int) var enemies_number = 10
export(int) var decorations_number = 20
export(int) var events_number = 2

var player_size = 0
var world_level = 0

# variables for difficculty
var difficulty_speed = 0
var difficulty_ai_time = 0.0
var difficulty_ai_prob = 0.0
var level_ceiling = 4000
var difficulty_color = Color( 1, 1, 1, 1 )

# check if can spawn things
var can_spawn: bool = true
var enemies_queue: int = 0

signal spawn_enemy(enemy)
signal spawn_decoration(decoration)
signal spawn_event(event)


func _ready():
	enemy_spawn_timer.connect("timeout", self, "queue_enemy_to_spawn")
	GameEvents.connect("increase_enemies_number", self, "_increase_enemies_number")
	GameEvents.connect("decrease_enemies_number", self, "_decrease_enemies_number")
	GameEvents.connect("stop_spawning_spawnable", self, "_stop_spawning")
	GameEvents.connect("start_spawning_spawnable", self, "_resume_spawning")
	GameEvents.connect("player_grew_up", self, "_update_size")


func _physics_process(delta):
	if can_spawn:
		if enemies_queue > 0:
			spawn_enemy()
			enemies_queue -= 1
		if get_tree().get_nodes_in_group("decorations").size() < decorations_number:
			spawn_decoration()
		if get_tree().get_nodes_in_group("events").size() < events_number:
			spawn_event()


func queue_enemy_to_spawn():
	var current_size = get_tree().get_nodes_in_group("enemies").size()
	if current_size < enemies_number:
		enemies_queue = ceil(enemies_number/10.0 as float) as int


func spawn_enemy():
	var player_size_division = player_size%(Global.size_division*enemies.size())
	var player_index = round(player_size_division/Global.size_division as float) as int
	var choose_index = 0
	var scale = 1.0
	var random_f = randf()
	if random_f < 0.2:
		choose_index = clamp(player_index-2, 0, enemies.size()-1)
		scale = rand_range(0.1, 1.0)
	elif random_f < 0.5:
		choose_index = clamp(player_index-1, 0, enemies.size()-1)
		scale = rand_range(0.43, 1.33)
	elif random_f < 0.8:
		choose_index = clamp(player_index, 0, enemies.size()-1)
		scale = rand_range(0.76, 1.66)
	else:
		choose_index = clamp(player_index+1, 0, enemies.size()-1)
		scale = rand_range(1.1, 2.0)
	
#	print("Player index: ", player_index, ", choose indes: ", choose_index)
	emit_signal("spawn_enemy", enemies[choose_index], scale, difficulty_speed \
	, difficulty_ai_time, difficulty_ai_prob, difficulty_color)


func spawn_decoration():
	emit_signal("spawn_decoration", decoration)


func spawn_event():
	var e
	var random_f = randf()
	if random_f < 0.5:
		e = event_mutation
	else:
		e = event_skill
	emit_signal("spawn_event", e)


func _update_size(size: int, amount: float):
	player_size = size
	if size >= level_ceiling:
		set_world_level(world_level+1)


func set_world_level(level):
	world_level = level
	
	set_difficulty()
	
	level_ceiling = Global.size_division*(world_level+1)*enemies.size()
	
	GameEvents.emit_signal("world_level_up", world_level)
	#print("level: ", world_level, " ,diffspeed: ", difficulty_speed, " ,world ceiling: ", level_ceiling)


func on_load(save: AlaGameSave):
	player_size = save.player_size as int
	var new_world_level = int(player_size/(enemies.size()*Global.size_division))
	world_level = new_world_level
	
	set_difficulty()
	
	level_ceiling = Global.size_division*(world_level+1)*enemies.size()
	can_spawn = true
	enemies_queue = 0
	
	#print("level: ", world_level, " ,diffspeed: ", difficulty_speed, " ,world ceiling: ", level_ceiling)


func set_difficulty():
	difficulty_speed = world_level * (Global.base_speed/10)
	difficulty_ai_time = 2.0 - (world_level*0.1)
	if difficulty_ai_time < 1.0: difficulty_ai_time = 1.0
	difficulty_ai_prob = 0.05 * world_level
	
	var gb = 1.0 - (world_level * 0.1)
	if gb < 0: gb = 0
	difficulty_color = Color(1, gb, gb, 1)


func _increase_enemies_number(amount):
	enemies_number += amount
	GameEvents.emit_signal("update_enemies_number", enemies_number)


func _decrease_enemies_number(amount):
	if enemies_number - amount < 0:
		enemies_number = 0
	enemies_number -= amount
	GameEvents.emit_signal("update_enemies_number", enemies_number)


func _stop_spawning():
	can_spawn = false


func _resume_spawning():
	can_spawn = true
