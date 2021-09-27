extends PopupPanel

onready var icon = $MargCont/Vbox/Icon
onready var title = $MargCont/Vbox/Title
onready var content = $MargCont/Vbox/Content

signal finished

func _ready():
	get_tree().paused = true


func unpause_tree():
	get_tree().paused = false
