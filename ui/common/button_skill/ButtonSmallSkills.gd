extends TextureButton

export(Texture) var icon setget set_icon

onready var progress = $TextureProgress

func disable_extended():
	disabled = true
	$AnimatedSprite.playing = false
	$AnimatedSprite.visible = false
	$DisablingTextureOver.visible = true
	$TextureProgress.visible = false


func enable_extended():
	disabled = false
	$AnimatedSprite.playing = true
	$AnimatedSprite.visible = true
	$DisablingTextureOver.visible = false
	$TextureProgress.visible = true


func set_icon(_icon):
	icon = _icon
	$Icon.texture = _icon


func _on_ButtonSmallSkills_pressed():
	pass
