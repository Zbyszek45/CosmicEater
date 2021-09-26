extends MarginContainer
class_name Message

enum ClearOption {SPAWNED_CLEAR, SPAWNED_IGNORE}

onready var timer = $Timer
onready var richlabel1 = $VBoxContainer/RichTextLabel
onready var richlabel2= $VBoxContainer/RichTextLabel2
onready var animation_player = $AnimationPlayer


func _ready():
	timer.connect("timeout", self, "start_destroying")
	animation_player.play("fade_in")


func set_message(player_pos: Vector2, text1: String, text2:String, time: float, should_clear: int):
	set_global_position(player_pos+Vector2(Global.wind_size.x/-2, Global.wind_size.y/-2))
	
	richlabel1.bbcode_text = text1
	richlabel2.bbcode_text = text2
	
	timer.wait_time = time
	timer.start()
	
	if should_clear == ClearOption.SPAWNED_CLEAR:
		pass


func start_destroying():
	animation_player.play("fade_out")


func destroy():
	queue_free()
