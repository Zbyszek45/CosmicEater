extends Node

var enemy_bouncy = preload("res://gameplay/enemies/enemy_bouncy/EnemyBouncy.tscn")
var enemy_mouthy = preload("res://gameplay/enemies/enemy_mouthy/EnemyMouthy.tscn")
var enemy_spiky = preload("res://gameplay/enemies/enemy_spiky/EnemySpiky.tscn")
var enemy_wavy = preload("res://gameplay/enemies/enemy_wavy/EnemyWavy.tscn")

var enemies = [
	enemy_bouncy,
	enemy_wavy,
	enemy_spiky,
	enemy_mouthy
]

var decoration = preload("res://gameplay/decorations/Decoration.tscn")

export(int) var enemies_number = 30
export(int) var decorations_number = 20

var player_size = 0

var can_spawn: bool = true

signal spawn_enemy(enemy)
signal spawn_decoration(decoration)


func _ready():
	GameEvents.connect("increase_enemies_number", self, "_increase_enemies_number")
	GameEvents.connect("decrease_enemies_number", self, "_decrease_enemies_number")
	GameEvents.connect("stop_spawning_spawnable", self, "_stop_spawning")
	GameEvents.connect("start_spawning_spawnable", self, "_resume_spawning")
	GameEvents.connect("player_grew_up", self, "_update_size")


func _physics_process(delta):
	if can_spawn:
		if get_tree().get_nodes_in_group("enemies").size() < enemies_number:
			spawn_enemy()
		if get_tree().get_nodes_in_group("decorations").size() < decorations_number:
			spawn_decoration()


func spawn_enemy():
	var player_index = round(player_size/Global.size_division as float) as int
	var choose_index = 0
	var random_f = randf()
	if random_f < 0.2:
		choose_index = clamp(player_index-2, 0, enemies.size()-1)
	elif random_f < 0.5:
		choose_index = clamp(player_index-1, 0, enemies.size()-1)
	elif random_f < 0.8:
		choose_index = clamp(player_index-0, 0, enemies.size()-1)
	else:
		choose_index = clamp(player_index+1, 0, enemies.size()-1)
	
	print("Player index: ", player_index, ", choose indes: ", choose_index)
	emit_signal("spawn_enemy", enemies[choose_index], 0)


func spawn_decoration():
	emit_signal("spawn_decoration", decoration)


func _update_size(size: int, amount: float):
	player_size = size


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
