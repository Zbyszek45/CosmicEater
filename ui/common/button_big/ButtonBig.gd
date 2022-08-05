extends TextureButton

export(Texture) var icon setget set_icon
export(String, MULTILINE) var text setget set_text
export(int) var number setget set_number


func disable_extended():
	disabled = true
	$AnimatedSprite.playing = false
	$AnimatedSprite.visible = false


func enable_extended():
	disabled = false
	$AnimatedSprite.playing = true
	$AnimatedSprite.visible = true


func set_icon(_icon):
	icon = _icon
	$TextureRect.texture = _icon


func set_text(_text):
	text = _text
	$RichTextLabel.bbcode_text = _text


func set_number(_number):
	number = _number
	$Number.text = str(_number)


func _on_ButtonBig_pressed():
	AudioHandler.play_effect(AudioHandler.Effect.GUI_CLICK)
