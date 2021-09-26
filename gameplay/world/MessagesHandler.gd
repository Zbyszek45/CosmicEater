extends Node


export(Resource) onready var planet_message = planet_message as AlaMessageRes
var planet_message_showed: bool = false

export(Resource) onready var starting_message = starting_message as AlaMessageRes
var start_message_showed: bool = false


func _ready():
	GameEvents.connect("player_grew_up", self, "check_size")


func check_size(player_size: int, amount: float):
	if not planet_message_showed and player_size >= planet_message.size_trigger:
		GameEvents.emit_signal("show_message", planet_message)
		planet_message_showed = true
	
	elif not start_message_showed and player_size >= starting_message.size_trigger:
		GameEvents.emit_signal("show_message", starting_message)
		start_message_showed = true
