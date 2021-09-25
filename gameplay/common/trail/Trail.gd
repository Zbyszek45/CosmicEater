extends Line2D

export(int) var length = 20

onready var timer = $Timer

func _ready():
	set_as_toplevel(true)
	timer.connect("timeout", self, "update")


func update():
	add_point(get_parent().global_position)
	while get_point_count() > length:
		remove_point(0)
