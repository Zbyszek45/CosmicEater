extends TextureButton

export(Texture) var icon setget set_icon

func set_icon(_icon):
	icon = _icon
	$TextureRect.texture = _icon


func _on_ButtonSmall_pressed():
	AudioHandler.play_effect(AudioHandler.Effect.GUI_CLICK)
