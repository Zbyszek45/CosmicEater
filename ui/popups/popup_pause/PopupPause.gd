extends "res://ui/popups/popup_base_accept/PopupBaseAccept.gd"

onready var exit_button = $MargCont/Vbox/Buttons/ExitButton
onready var save_exit_button = $MargCont/Vbox/Buttons/SaveExitButton


func _ready():
	exit_button.connect("pressed", self, "on_exit_pressed")
	save_exit_button.connect("pressed", self, "on_save_exit_pressed")


func on_exit_pressed():
	Global.delete_save()
	emit_signal("finished")
	#ScenesHandler.switch_scene(ScenesHandler.MENU)
	GameEvents.emit_signal("end_game")


func on_save_exit_pressed():
	emit_signal("finished")
	GameEvents.emit_signal("save_game_state")
	get_tree().quit()


func _on_accept():
	pass
