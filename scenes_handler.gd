extends Node

enum {MENU, WORLD}

var menu : PackedScene = preload("res://ui/menu/Menu.tscn")
var world : PackedScene = preload("res://gameplay/world/World.tscn")

var current_scene : Node = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func switch_scene(new_scene_choice) -> void:
	call_deferred("_deferred_switch_scene", new_scene_choice)

func _deferred_switch_scene(new_scene_choice) -> void:
	current_scene.queue_free()
	
	var new_scene
	if new_scene_choice == MENU:
		new_scene = menu
	elif new_scene_choice == WORLD:
		new_scene = world
	
	
	current_scene = new_scene.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
