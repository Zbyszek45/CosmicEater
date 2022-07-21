extends Control


func _ready():
	set_position_scale(Global.js_side, Global.js_size)

func set_position_scale(side, scale) -> void:
	var js_size: Vector2 = $Joystick.texture.get_size() * 2 / 3
	var js_scale: float
	if scale == Global.JsSizes.SMALL:
		js_scale = 0.6
	if scale == Global.JsSizes.MEDIUM:
		js_scale = 1.0
	if scale == Global.JsSizes.BIG:
		js_scale = 1.4
	if scale == Global.JsSizes.HUGE:
		js_scale = 1.8
	
	set_js_anchor(side)
	$Joystick.scale = Vector2(js_scale, js_scale)
#	margin_top = -1 * (js_size.y * js_scale)
#	if side == Global.JsSides.LEFT:
#		$Joystick.position.x = js_size.x * js_scale
#	if side == Global.JsSides.RIGHT:
#		$Joystick.position.x = -1 * js_size.x * js_scale\
	margin_top = -140 * js_scale
	if side == Global.JsSides.LEFT:
		$Joystick.position.x = 140 * js_scale
	if side == Global.JsSides.RIGHT:
		$Joystick.position.x = -140 * js_scale

func set_js_anchor(side) -> void:
	if side == Global.JsSides.LEFT:
		anchor_left = 0
		anchor_top = 1
		anchor_right = 0
		anchor_bottom = 1
	elif side == Global.JsSides.RIGHT:
		anchor_left = 1
		anchor_top = 1
		anchor_right = 1
		anchor_bottom = 1
