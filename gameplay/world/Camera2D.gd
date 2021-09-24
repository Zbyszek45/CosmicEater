extends Camera2D

onready var tween = $Tween

func _ready():
	GameEvents.connect("player_grow_up", self, "animate_camera")


func animate_camera(amount):
	tween.interpolate_property(self, "zoom", Vector2(1+amount, 1+amount), Vector2(1, 1) \
		, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
