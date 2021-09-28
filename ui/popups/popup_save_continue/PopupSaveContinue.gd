extends "res://ui/popups/popup_base_accept/PopupBaseAccept.gd"

onready var reject_button = $MargCont/Vbox/Buttons/RejectButton


func _ready():
	reject_button.connect("pressed", self, "on_rejectButton_pressed")


func _on_accept():
	Global.continue_save = true
	ScenesHandler.switch_scene(ScenesHandler.WORLD)


func on_rejectButton_pressed():
	Global.delete_save()
	
	unpause_tree()
	emit_signal("finished")
