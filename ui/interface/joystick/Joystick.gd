extends Sprite
class_name Joystick

var js_radius: float
var js_button_radius: Vector2
var deadzone: float

var finger_index = null

func _process(_delta):
	if finger_index == null:
		$JoystickButton.position = lerp($JoystickButton.position, Vector2(0,0) - js_button_radius, 0.2)

func _ready():
	js_radius = self.texture.get_width() / 2.0
	js_button_radius = Vector2($JoystickButton.normal.get_width() / 2.0, $JoystickButton.normal.get_height() / 2.0)
	deadzone = js_radius / 5.0

func _input(event):
	if event is InputEventScreenDrag:
		if (event.position - global_position).length() <= js_radius * global_scale.y or event.get_index() == finger_index:
			$JoystickButton.set_global_position(event.position - js_button_radius * global_scale)
			if get_js_button_pos().length() > js_radius:
				$JoystickButton.set_position(get_js_button_pos().normalized() * js_radius - js_button_radius)
			
			finger_index = event.get_index()
	
	if event is InputEventScreenTouch and not event.is_pressed() and event.get_index() == finger_index:
		finger_index = null

func get_js_button_pos() -> Vector2:
	return $JoystickButton.position + js_button_radius

func get_movement() -> Vector2:
	if get_js_button_pos().length() < deadzone:
		return Vector2(0, 0)
	return get_js_button_pos() / js_radius
