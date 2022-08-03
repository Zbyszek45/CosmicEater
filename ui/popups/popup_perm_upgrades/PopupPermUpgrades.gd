extends "res://ui/popups/popup_base/PopupBase.gd"

onready var accept_button = $MargCont/Vbox/Buttons/AcceptButton


func _ready():
	accept_button.connect("pressed", self, "on_accept_pressed")


func on_accept_pressed():
	Global.save_player()
	emit_signal("finished")
