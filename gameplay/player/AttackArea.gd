extends Area2D

var smaller_bodies = []


func _ready():
	connect("body_entered", self, "on_body_AreaWatcher_entered")
	connect("body_exited", self, "on_body_AreaWatcher_exited")
	connect("area_entered", self, "on_area_AreaWatcher_entered")
	connect("area_exited", self, "on_area_AreaWatcher_exited")


func on_body_AreaWatcher_entered(body: Node):
	if body.has_method("get_scale"):
		if get_parent().can_eat(body.get_scale()):
			smaller_bodies.append(body)
	else:
		Global.show_error("res://gameplay/player/AttackArea.gd", "Body don't have method: "+body.name)


func on_body_AreaWatcher_exited(body: Node):
	smaller_bodies.erase(body)


func on_area_AreaWatcher_entered(area: Area2D):
	smaller_bodies.append(area)


func on_area_AreaWatcher_exited(area: Area2D):
	smaller_bodies.erase(area)
