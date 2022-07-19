extends "res://ui/popups/popup_base/PopupBase.gd"

onready var accept_button = $MargCont/Vbox/Buttons/AcceptButton

var on_accept_method = "_on_accept"

func _ready():
	accept_button.connect("pressed", self, "on_accept_pressed")


func on_accept_pressed():
	
	if has_method(on_accept_method):
		call(on_accept_method)
	else:
		Global.show_error("res://ui/popups/popup_base/PopupInformation.gd" \
		, "Inherited scene dont have method '_on_accept_and_resume'")
	
	
	emit_signal("finished")


func _on_accept():
	pass
