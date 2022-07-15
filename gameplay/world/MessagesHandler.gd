extends Node

export(Resource) onready var starting_message = starting_message as AlaMessageRes
var start_message_showed: bool = false

export(Resource) onready var new_world_message = new_world_message as AlaMessageRes

func _ready():
	GameEvents.connect("player_grew_up", self, "check_size")


func check_size(player_size: int, amount: float):
	if not start_message_showed and player_size >= starting_message.size_trigger:
		GameEvents.emit_signal("show_message", starting_message)
		start_message_showed = true


func show_new_world_message(level):
	if level > 0:
		GameEvents.emit_signal("show_message", new_world_message)


func on_load(save: AlaGameSave):
	if save.player_size > starting_message.size_trigger: start_message_showed = true
