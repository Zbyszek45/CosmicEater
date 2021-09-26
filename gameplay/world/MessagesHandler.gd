extends Node


export(Resource) onready var starting_message = starting_message as AlaMessageRes
var start_message_showed: bool = false


func _ready():
	GameEvents.connect("player_grew_up", self, "check_size")


func check_size(player_size: int, amount: float):
	if not start_message_showed and player_size >= starting_message.size_trigger:
		# show message
		start_message_showed = true
