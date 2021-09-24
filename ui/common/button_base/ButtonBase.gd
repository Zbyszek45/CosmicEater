extends TextureButton


export(Texture) var icon setget set_icon


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
