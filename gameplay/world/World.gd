extends Node2D

var message_scene = preload("res://gameplay/message/Message.tscn")

onready var spawn_point = $SpawnPoint
onready var spawn_strategy = $SpawnStrategy
onready var enemies = $Enemies
onready var decorations = $Decorations
onready var messages = $Messages
onready var player = $Player
onready var interface = $CanvasInterface/Interface

func _ready():
	randomize()
	
	spawn_strategy.connect("spawn_enemy", self, "spawn_enemy")
	spawn_strategy.connect("spawn_decoration", self, "spawn_decoration")
	
	set_children_variables()
	
	spawn_message()


func set_children_variables():
	player.joystick = interface.joystick


func _input(event):
	# Zoming for debug
	if event is InputEventKey:
		if event.scancode == KEY_G:
			$Player/Camera2D.zoom.x -= 0.05
			$Player/Camera2D.zoom.y -= 0.05
		if event.scancode == KEY_H:
			$Player/Camera2D.zoom.x += 0.05
			$Player/Camera2D.zoom.y += 0.05


func spawn_enemy(enemy: PackedScene):
	var new_enemy: EnemyBase = enemy.instance()
	new_enemy.global_position = spawn_point.get_rand_point(player.global_position)
	enemies.add_child(new_enemy)
	new_enemy.set_enemy(player)


func spawn_decoration(decoration: PackedScene):
	var new_decoration: Decoration = decoration.instance()
	new_decoration.global_position = spawn_point.get_rand_point(player.global_position)
	decorations.add_child(new_decoration)
	new_decoration.set_decoration(player)


func spawn_message():
	var new_message = message_scene.instance()
	messages.add_child(new_message)
	new_message.set_message(player.global_position \
	, "[center]Eat [color=green][wave amp=100]smaller[/wave][/color]\nRun away from [color=red][shake level=20]bigger" \
	, "[center]Catch [color=yellow][shake amp=100]stars[/shake][/color] and [color=blue][wave level=20]comets[/wave][/color] for upgrades" \
	, 10, Message.SPAWNED_IGNORE)
