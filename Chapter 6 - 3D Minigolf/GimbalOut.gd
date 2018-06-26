extends Spatial

var cam_speed = PI/2
var zoom_speed = 0.1
var zoom = 0.5

func _ready():
	$GimbalIn.rotate_x(-PI/6)

func _input(event):
	if event.is_action_pressed('cam_zoom_in'):
		zoom -= zoom_speed
	if event.is_action_pressed('cam_zoom_out'):
		zoom += zoom_speed

func _process(delta):
	zoom = clamp(zoom, 0.1, 2)
	scale = Vector3(1, 1, 1) * zoom
	if Input.is_action_pressed('cam_left'):
		rotate_y(-cam_speed * delta)
	if Input.is_action_pressed('cam_right'):
		rotate_y(cam_speed * delta)
	if Input.is_action_pressed('cam_up'):
		$GimbalIn.rotate_x(-cam_speed * delta)
	if Input.is_action_pressed('cam_down'):
		$GimbalIn.rotate_x(cam_speed * delta)
	$GimbalIn.rotation.x = clamp($GimbalIn.rotation.x, -PI/2, -0.2)