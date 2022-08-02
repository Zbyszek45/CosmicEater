extends AnimatedSprite

onready var body_area = $BodyArea
onready var life_timer = $Timer

var should_vanish: bool = false

var player

func _ready():
	add_to_group("spawnable")
	add_to_group("events")
	GameEvents.connect("stop_spawning_spawnable", self, "vanish")
	life_timer.connect("timeout", self, "vanish")


func set_event(_player):
	player = _player


func _physics_process(delta):
	if abs(player.global_position.x - global_position.x) > Global.range_spawn.x + 100:
		queue_free()
	if abs(player.global_position.y - global_position.y) > Global.range_spawn.y + 100:
		queue_free()
	
	if should_vanish:
		modulate.a -= 1.0*delta
		if modulate.a <= 0.1:
			queue_free()


func vanish():
	should_vanish = true


func scale_it(amount: float) -> void:
	pass
