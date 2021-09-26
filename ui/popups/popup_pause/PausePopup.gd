extends "res://ui/popups/popup_base/PopupBase.gd"

onready var exit_button = $MargCont/Vbox/Buttons/ExitButton

func _ready():
	exit_button.connect("pressed", self, "on_exit_pressed")


func on_exit_pressed():
	unpause_tree()
	ScenesHandler.switch_scene(ScenesHandler.MENU)


func _on_accept():
	pass
