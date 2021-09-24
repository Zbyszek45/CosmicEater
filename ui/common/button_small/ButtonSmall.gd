extends TextureButton

export(Texture) var icon setget set_icon

func set_icon(_icon):
	icon = _icon
	$TextureRect.texture = _icon
