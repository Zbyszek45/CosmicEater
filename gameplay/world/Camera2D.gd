extends Camera2D

onready var tween = $Tween
onready var dust_particles = $DustParticles
onready var star_particles = $StarParticles

func _ready():
	GameEvents.connect("player_grew_up", self, "animate_camera")
	
	if dust_particles.emission_shape == CPUParticles2D.EMISSION_SHAPE_RECTANGLE:
		dust_particles.emission_rect_extents.x = Global.wind_size.x + 100
		dust_particles.emission_rect_extents.y = Global.wind_size.y + 100
	else:
		Global.show_error("res://gameplay/world/Camera2D.gd"\
		, "Particles dont have rect emmision shape")
	
	if star_particles.emission_shape == CPUParticles2D.EMISSION_SHAPE_RECTANGLE:
		star_particles.emission_rect_extents.x = Global.wind_size.x + 100
		star_particles.emission_rect_extents.y = Global.wind_size.y + 100
	else:
		Global.show_error("res://gameplay/world/Camera2D.gd"\
		, "Particles dont have rect emmision shape")

func animate_camera(size, amount):
	if amount >= 1.0: amount = 0.9
	tween.interpolate_property(self, "zoom", Vector2(1.0-amount, 1.0-amount), Vector2(1, 1) \
		, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
