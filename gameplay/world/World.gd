extends Node2D

var message_scene = preload("res://gameplay/message/Message.tscn")

onready var spawn_point = $SpawnPoint
onready var spawn_strategy = $SpawnStrategy
onready var enemies = $Enemies
onready var decorations = $Decorations
onready var messages = $Messages
onready var player = $Player
onready var interface = $CanvasInterface/Interface
onready var popups = $Popups
onready var canvas = $CanvasInterface
onready var timer_timer = $TimeTimer
onready var messages_handler = $MessagesHandler


export(Resource) var initial_save = initial_save as AlaGameSave


func _ready():
	randomize()
	
	spawn_strategy.connect("spawn_enemy", self, "spawn_enemy")
	spawn_strategy.connect("spawn_decoration", self, "spawn_decoration")
	GameEvents.connect("show_message", self, "spawn_message")
	GameEvents.connect("save_game_state", self, "save_game")
	
	load_save()
	set_children_variables()
	after_ready()


func load_save():
	var save: AlaGameSave
	if Global.continue_save:
		save = Global.load_save()
		if save == null:
			Global.show_error("res://gameplay/world/World.gd", "Should load save but not existing")
			save = initial_save
		Global.delete_save()
	else:
		save = initial_save
	
	# call group seems very looose, it will call but after some time
#	get_tree().call_group("saved", "on_load", save)
	
	# this is better because its strict
	for i in get_tree().get_nodes_in_group("saved"):
		if i.has_method("on_load"):
			i.on_load(save)
		else:
			Global.show_error("res://gameplay/world/World.gd", i.get_path()+" dont have method")


func set_children_variables():
	player.joystick = interface.joystick
	popups.canvas = canvas


func after_ready():
	messages_handler.check_size(player.size, 0)


func save_game():
	print("saving")
	var new_save = AlaGameSave.new()
	new_save.player_size = player.size as int
	new_save.time_h = timer_timer.h as int
	new_save.time_m = timer_timer.m as int
	new_save.time_s = timer_timer.s as int
	
	var dir = Directory.new()
	if not dir.dir_exists(Global.SAVE_FOLDER_PATH):
		dir.make_dir_recursive(Global.SAVE_FOLDER_PATH)
	
	ResourceSaver.save(Global.SAVE_FOLDER_PATH.plus_file(Global.SAVE_NAME_PATH), new_save)


func _input(event):
	# Zoming for debug
	if event is InputEventKey:
		if event.scancode == KEY_G:
			$Player/Camera2D.zoom.x -= 0.05
			$Player/Camera2D.zoom.y -= 0.05
		if event.scancode == KEY_H:
			$Player/Camera2D.zoom.x += 0.05
			$Player/Camera2D.zoom.y += 0.05


func spawn_enemy(enemy: PackedScene, scale, difficulty_speed, _difficulty_ai_time, _difficulty_ai_prob):
	var new_enemy: EnemyBase = enemy.instance()
	new_enemy.global_position = spawn_point.get_rand_point(player.global_position)
	enemies.add_child(new_enemy)
	new_enemy.set_enemy(player, scale, difficulty_speed, _difficulty_ai_time, _difficulty_ai_prob)


func spawn_decoration(decoration: PackedScene):
	var new_decoration: Decoration = decoration.instance()
	new_decoration.global_position = spawn_point.get_rand_point(player.global_position)
	decorations.add_child(new_decoration)
	new_decoration.set_decoration(player)


func spawn_message(message_info):
	var new_message = message_scene.instance()
	messages.add_child(new_message)
	new_message.set_message(player.global_position, message_info)
