extends Node


var background_music = preload("res://audio/OutThere.ogg")
var impact_sound = preload("res://audio/impactBell_heavy_000.ogg")
var gui_sound = preload("res://audio/bong_001.ogg")


enum Effect {EAT, GUI_CLICK}

var background_player: AudioStreamPlayer
var effect_player: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	background_player = AudioStreamPlayer.new()
	effect_player = AudioStreamPlayer.new()
	
	add_child(background_player)
	add_child(effect_player)
	
	background_player.stream = background_music
	if Global.music:
		background_player.play()


func play_background_music():
	if !background_player.playing and Global.music:
		background_player.play()


func stop_background_music():
	if background_player.playing:
		background_player.stop()


func play_effect(type):
	if Global.sound:
		if type == Effect.EAT:
			effect_player.stream = impact_sound
		else:
			effect_player.stream = gui_sound
		
		effect_player.play()
