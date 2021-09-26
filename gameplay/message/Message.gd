extends MarginContainer
class_name Message

const SPAWNED_CLEAR = true
const SPAWNED_IGNORE = false

onready var timer = $Timer
onready var richlabel1 = $VBoxContainer/RichTextLabel
onready var richlabel2= $VBoxContainer/RichTextLabel2


func _ready():
	timer.connect("timeout", self, "destroy")


func set_message(player_pos: Vector2, text1: String, text2:String, time: float, should_clear: bool):
	set_global_position(player_pos+Vector2(Global.wind_size.x/-2, Global.wind_size.y/-2))
	
	richlabel1.bbcode_text = text1
	richlabel2.bbcode_text = text2
	
	timer.wait_time = time
	timer.start()
	
	if should_clear:
		pass


func destroy():
	queue_free()
