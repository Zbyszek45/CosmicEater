extends Node2D

onready var animated_sprite = $AnimatedSprite

func _ready():
	animated_sprite.connect("animation_finished", self, "change_screen")
	
	animated_sprite.frame = 0
	animated_sprite.play("start")


func change_screen():
	ScenesHandler.switch_scene(ScenesHandler.WORLD)
