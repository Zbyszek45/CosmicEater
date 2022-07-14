extends Node

enum Type {PAUSE, MUTATION, SKILL}

var popup_pause_scene: PackedScene = preload("res://ui/popups/popup_pause/PopupPause.tscn")
var popup_mutation_selection: PackedScene = preload("res://ui/popups/popup_mutation_selection/PopupMutationSelection.tscn")
var popup_skill_selection: PackedScene = preload("res://ui/popups/popup_skill_selection/PopupSkillSelection.tscn")

var popup_dict = {
	Type.PAUSE: popup_pause_scene,
	Type.MUTATION: popup_mutation_selection,
	Type.SKILL: popup_skill_selection
}

var popups := []
var canvas: CanvasLayer = null

# funcref
var get_mutations_ref: FuncRef
var get_skills_ref: FuncRef

func _ready():
	GameEvents.connect("show_popup_pause", self, "queue_popup", [Type.PAUSE])
	GameEvents.connect("show_popup_mutation_selection", self, "queue_popup", [Type.MUTATION])
	GameEvents.connect("show_popup_skill_selection", self, "queue_popup", [Type.SKILL])


func queue_popup(type):
	popups.append(type)


func _physics_process(delta):
	if popups.size() > 0:
		if canvas:
			get_tree().paused = true
			var popup = popup_dict[popups[0]].instance()
			canvas.add_child(popup)
			popup.connect("finished", self, "resume", [popup])
			
			#setup based by type
			if popups[0] == Type.MUTATION:
				popup.set_popup(get_mutations_ref.call_func())
			elif popups[0] == Type.SKILL:
				popup.set_popup(get_skills_ref.call_func())
			
			popup.popup()
		else:
			Global.show_error("res://gameplay/world/Popups.gd", "Canvas is null")


#func _show_popup_pause():
#	if canvas:
#		var popup
#		get_tree().paused = true
#		popup = popup_pause_scene.instance()
#		canvas.add_child(popup)
#		popup.connect("finished", self, "resume", [popup])
#		popups.append(popup)
#		popup.popup()
#	else:
#		Global.show_error("res://gameplay/world/Popups.gd", "Canvas is null")
#
#
#func _show_popup_mutation_selection():
#	if canvas:
#		var popup
#		get_tree().paused = true
#		popup = popup_mutation_selection.instance()
#		canvas.add_child(popup)
#		popup.connect("finished", self, "resume", [popup])
#		popup.set_popup(get_mutations_ref.call_func())
#		popups.append(popup)
#		popup.popup()
#	else:
#		Global.show_error("res://gameplay/world/Popups.gd", "Canvas is null")
#
#
#func _show_popup_skill_selection():
#	if canvas:
#		var popup
#		print("pause game")
#		get_tree().paused = true
#		popup = popup_skill_selection.instance()
#		canvas.add_child(popup)
#		popup.connect("finished", self, "resume", [popup])
#		popup.set_popup(get_skills_ref.call_func())
#		popups.append(popup)
#		popup.popup()
#	else:
#		Global.show_error("res://gameplay/world/Popups.gd", "Canvas is null")


func resume(p):
	popups.remove(0)
	p.queue_free()
	
	get_tree().paused = false

