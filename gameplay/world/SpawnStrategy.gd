extends Node

var test_enemy = preload("res://gameplay/enemies/test_enemy/TestEnemy.tscn")

var decoration = preload("res://gameplay/decorations/Decoration.tscn")

export(int) var enemies_number = 10
export(int) var decorations_number = 20

var can_spawn: bool = true

signal spawn_enemy(enemy)
signal spawn_decoration(decoration)


func _ready():
	GameEvents.connect("increase_enemies_number", self, "_increase_enemies_number")
	GameEvents.connect("decrease_enemies_number", self, "_decrease_enemies_number")
	GameEvents.connect("stop_spawning_spawnable", self, "_stop_spawning")
	GameEvents.connect("start_spawning_spawnable", self, "_resume_spawning")


func _physics_process(delta):
	if can_spawn:
		if get_tree().get_nodes_in_group("enemies").size() < enemies_number:
			spawn_enemy()
		if get_tree().get_nodes_in_group("decorations").size() < decorations_number:
			spawn_decoration()


func spawn_enemy():
	emit_signal("spawn_enemy", test_enemy)


func spawn_decoration():
	emit_signal("spawn_decoration", decoration)


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
