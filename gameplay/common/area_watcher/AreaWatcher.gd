extends Area2D

var bigger_bodies = []


func _ready():
	connect("body_entered", self, "on_body_AreaWatcher_entered")
	connect("body_exited", self, "on_body_AreaWatcher_exited")


func on_body_AreaWatcher_entered(body: Node):
	if body.has_method("can_eat"):
		if body.can_eat(scale.x):
			bigger_bodies.append(body)
	else:
		Global.show_error("res://gameplay/common/area_watcher/AreaWatcher.gd", "Body don't have method: "+body.name)


func on_body_AreaWatcher_exited(body: Node):
	bigger_bodies.erase(body)


func is_dangerous() -> bool:
	if bigger_bodies.size() <= 0:
		return false
	else:
		 return true
