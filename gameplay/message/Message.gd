extends MarginContainer
class_name Message

onready var timer = $Timer
onready var richlabel1 = $VBoxContainer/RichTextLabel
onready var richlabel2= $VBoxContainer/RichTextLabel2
onready var animation_player = $AnimationPlayer


func _ready():
	timer.connect("timeout", self, "start_destroying")
	animation_player.play("fade_in")


func set_message(player_pos: Vector2, message_info):
	set_global_position(player_pos+Vector2(Global.wind_size.x/-2, Global.wind_size.y/-2))
	
	richlabel1.bbcode_text = message_info.text1
	richlabel2.bbcode_text = message_info.text2
	
	timer.wait_time = message_info.time
	timer.start()
	
	if message_info.should_clear:
		pass


func start_destroying():
	animation_player.play("fade_out")


func destroy():
	queue_free()
