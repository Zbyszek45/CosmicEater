extends "res://gameplay/events/sprite_event_base/SpriteEventBase.gd"


func _ready():
	body_area.connect("area_entered", self, "on_area_entered")


func on_area_entered(area):
	GameEvents.emit_signal("show_popup_mutation_selection")
	queue_free()


func vanish():
	pass
