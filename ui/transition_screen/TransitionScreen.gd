extends Control

onready var animated_sprite = $AnimatedSprite


func _ready():
	animated_sprite.connect("animation_finished", self, "change_screen")
	
	animated_sprite.frame = 0
	animated_sprite.play("start")


#func _input(event):
#	if event is InputEventMouseButton or event is InputEventScreenTouch:
#		change_screen()


func change_screen():
	ScenesHandler.switch_scene(ScenesHandler.WORLD)
