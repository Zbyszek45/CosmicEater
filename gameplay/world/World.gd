extends Node2D

var message_scene = preload("res://gameplay/message/Message.tscn")

onready var spawn_point = $SpawnPoint
onready var spawn_strategy = $SpawnStrategy
onready var enemies = $Enemies
onready var decorations = $Decorations
onready var events = $Events
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
	spawn_strategy.connect("spawn_event", self, "spawn_event")
	GameEvents.connect("show_message", self, "spawn_message")
	GameEvents.connect("save_game_state", self, "save_game")
	GameEvents.connect("spawn_support", self, "spawn_support")
	GameEvents.connect("world_level_up", self, "world_level_up")
	
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
	popups.get_mutations_ref = funcref(self, "get_mutations")
	popups.get_skills_ref = funcref(self, "get_skills")


func after_ready():
	messages_handler.check_size(player.size, 0)


func save_game():
	print("saving")
	var new_save = AlaGameSave.new()
	new_save.player_size = player.size as int
	new_save.mutation_speed = player.mutations.mutation_speed_number as int
	new_save.mutation_magic = player.mutations.mutation_magic_number as int
	new_save.mutation_growth = player.mutations.mutation_growth_number as int
	new_save.mutation_hunger = player.mutations.mutation_hunger_number as int
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
		if event.scancode == KEY_M:
			GameEvents.emit_signal("show_popup_mutation_selection")
		if event.scancode == KEY_S:
			GameEvents.emit_signal("show_popup_skill_selection")


func spawn_enemy(enemy: PackedScene, scale, difficulty_speed, _difficulty_ai_time, _difficulty_ai_prob):
	var new_enemy: EnemyBase = enemy.instance()
	new_enemy.global_position = spawn_point.get_rand_point(player.global_position)
	enemies.add_child(new_enemy)
	new_enemy.set_enemy(player, scale, difficulty_speed, _difficulty_ai_time, _difficulty_ai_prob)


func spawn_decoration(decoration: PackedScene):
	var new_decoration: Decoration = decoration.instance()
	new_decoration.global_position = spawn_point.get_rand_point_decoratives(player.global_position)
	decorations.add_child(new_decoration)
	new_decoration.set_decoration(player)


func spawn_event(event: PackedScene):
	var new_event = event.instance()
	new_event.global_position = spawn_point.get_rand_point(player.global_position)
	events.add_child(new_event)
	new_event.set_event(player)


func spawn_message(message_info):
	var new_message = message_scene.instance()
	messages.add_child(new_message)
	new_message.set_message(player.global_position, message_info)


func spawn_support(support: PackedScene, skill):
	# deleting existing support
	for i in get_tree().get_nodes_in_group("support"):
		i.queue_free()
	# creating a new one
	var new_support = support.instance()
	new_support.player = player
	enemies.add_child(new_support)
	new_support.global_position = player.global_position
	new_support.set_support(skill)


func world_level_up(_level):
	player.global_position = Vector2(0, 0)


func get_mutations() -> Dictionary:
	var mutations = {
		Global.Mutation.SPEED: player.mutations.mutation_speed_number,
		Global.Mutation.MAGIC: player.mutations.mutation_magic_number,
		Global.Mutation.GROWTH: player.mutations.mutation_growth_number,
		Global.Mutation.HUNGER: player.mutations.mutation_hunger_number
	}
	return mutations


func get_skills() -> Dictionary:
	var skills = {
		Global.Skill.DASHIN: player.skills.skill_dashin,
		Global.Skill.DASHOUT: player.skills.skill_dashout,
		Global.Skill.PUFF: player.skills.skill_puff,
		Global.Skill.SUMMON: player.skills.skill_summon
	}
	return skills
