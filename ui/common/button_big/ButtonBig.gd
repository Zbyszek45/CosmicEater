extends TextureButton

export(Texture) var icon setget set_icon
export(String, MULTILINE) var text setget set_text


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
	$MarginContainer/VBoxContainer/TextureRect.texture = _icon


func set_text(_text):
	text = _text
	$MarginContainer/VBoxContainer/RichTextLabel.bbcode_text = _text
