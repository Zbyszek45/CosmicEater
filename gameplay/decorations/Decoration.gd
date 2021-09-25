extends Sprite
class_name Decoration


export(Array, Texture) var textures
var player: Player

func _ready():
	add_to_group("decorations")
	add_to_group("spawnable")
	
	texture = textures[randi() % textures.size()]
	
	var rand_scale_value = rand_range(0.5, 1.0)
	scale = Vector2(rand_scale_value, rand_scale_value)
	
	rotate(rand_range(-PI, PI))


func set_decoration(_player) -> void:
	player = _player


func _physics_process(delta):
	if global_position.distance_to(player.global_position) > Global.range_limit:
		destroy()


func scale_it(amount: float) -> void:
	if scale.x + amount < 0.1: scale = Vector2(0.1, 0.1)
	else: scale += Vector2(amount, amount)
	
	#when scaling up
	if amount > 0: amount = amount + amount
	
	var dir = (player.global_position - global_position)*amount
	global_position -= dir


func destroy():
	queue_free()
