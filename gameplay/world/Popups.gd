extends Node

var popup_pause_scene: PackedScene = preload("res://ui/popups/popup_pause/PopupPause.tscn")

var popup = null
var canvas: CanvasLayer = null


func _ready():
	GameEvents.connect("show_popup_pause", self, "_show_popup_pause")


func _show_popup_pause():
	if canvas:
		popup = popup_pause_scene.instance()
		canvas.add_child(popup)
		popup.connect("finished", self, "resume")
		popup.popup()
	else:
		Global.show_error("res://gameplay/world/Popups.gd", "Canvas is null")


func resume():
	if popup != null:
		popup.queue_free()
		popup = null
