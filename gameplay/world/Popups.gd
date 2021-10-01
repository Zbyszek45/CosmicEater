extends Node

var popup_pause_scene: PackedScene = preload("res://ui/popups/popup_pause/PopupPause.tscn")
var popup_mutation_selection: PackedScene = preload("res://ui/popups/popup_mutation_selection/PopupMutationSelection.tscn")

var popup = null
var canvas: CanvasLayer = null

# funcref
var get_mutations_ref: FuncRef

func _ready():
	GameEvents.connect("show_popup_pause", self, "_show_popup_pause")
	GameEvents.connect("show_popup_mutation_selection", self, "_show_popup_mutation_selection")


func _show_popup_pause():
	if canvas:
		popup = popup_pause_scene.instance()
		canvas.add_child(popup)
		popup.connect("finished", self, "resume")
		popup.popup()
	else:
		Global.show_error("res://gameplay/world/Popups.gd", "Canvas is null")


func _show_popup_mutation_selection():
	if canvas:
		popup = popup_mutation_selection.instance()
		canvas.add_child(popup)
		popup.connect("finished", self, "resume")
		popup.set_popup(get_mutations_ref.call_func())
		popup.popup()
	else:
		Global.show_error("res://gameplay/world/Popups.gd", "Canvas is null")


func resume():
	if popup != null:
		popup.queue_free()
		popup = null
