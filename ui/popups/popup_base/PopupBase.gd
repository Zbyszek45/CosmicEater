extends PopupPanel


onready var accept_button = $MargCont/Vbox/Buttons/AcceptButton
onready var icon = $MargCont/Vbox/Icon
onready var title = $MargCont/Vbox/Title
onready var content = $MargCont/Vbox/Content

signal finished
var on_accept_method = "_on_accept"

func _ready():
	accept_button.connect("pressed", self, "on_accept_pressed")
	get_tree().paused = true


func on_accept_pressed():
	if has_method(on_accept_method):
		call(on_accept_method)
	else:
		Global.show_error("res://ui/popups/popup_base/PopupBase.gd" \
		, "Inherited scene dont have method '_on_accept_and_resume'")
	
	unpause_tree()
	emit_signal("finished")


func unpause_tree():
	get_tree().paused = false
