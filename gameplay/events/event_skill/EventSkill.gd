extends "res://gameplay/events/sprite_event_base/SpriteEventBase.gd"

var push_force: Vector2 = Vector2.ZERO

func _ready():
	add_to_group("attackable")
	body_area.connect("area_entered", self, "on_area_entered")


func on_area_entered(area):
	GameEvents.emit_signal("show_popup_skill_selection")
	queue_free()


func _physics_process(delta):
	if should_vanish:
		modulate.a -= 1.0*delta
		if modulate.a <= 0.1:
			queue_free()
	
	global_position += push_force * delta
	
	if push_force != Vector2.ZERO:
		push_force /= 1.5
		if push_force.x < 1 and push_force.y < 1:
			push_force = Vector2.ZERO


func vanish():
	pass


func push(force):
	push_force = force
