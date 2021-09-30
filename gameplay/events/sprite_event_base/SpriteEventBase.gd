extends AnimatedSprite

onready var body_area = $BodyArea
onready var life_timer = $Timer

var should_vanish: bool = false

func _ready():
	add_to_group("spawnable")
	add_to_group("events")
	GameEvents.connect("stop_spawning_spawnable", self, "vanish")
	life_timer.connect("timeout", self, "vanish")


func set_event(player):
	pass


func _physics_process(delta):
	if should_vanish:
		modulate.a -= 1.0*delta
		if modulate.a <= 0.1:
			queue_free()


func vanish():
	should_vanish = true


func scale_it(amount: float) -> void:
	pass
