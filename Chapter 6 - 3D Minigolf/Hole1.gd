extends Spatial

var state
var current_camera
var power = 0
var power_dir = 1
var power_speed = 100
var aim = 0
var aim_dir = 1
var aim_speed = 1.1
var hole_dir
enum {TEST, SET_AIM, SET_POWER, SHOOT, WIN}

func _ready():
	$Arrow.hide()
	#$Arrow.scale = Vector3(0.5, 0.5, 0.5)
	$Ball.transform.origin = $Tee.transform.origin
	change_state(SET_AIM)
	#current_camera = $Camera
	#current_camera.current = true

func set_start_angle():
	var hole_pos2 = Vector2($Hole.transform.origin.z, $Hole.transform.origin.x)
	var ball_pos2 = Vector2($Ball.transform.origin.z, $Ball.transform.origin.x)
	hole_dir = (ball_pos2 - hole_pos2).angle()
	$Arrow.rotation.y = hole_dir

func set_start_angle2():
	var hole_pos = $Hole.transform.origin
	hole_pos.y = 0
	var ball_pos = $Ball.transform.origin
	ball_pos.y = 0
	hole_dir = (ball_pos - hole_pos).angle()
	$Arrow.rotation.y = hole_dir

func change_state(new_state):
	state = new_state
	match state:
		TEST:
			$Arrow.transform.origin = $Ball.transform.origin
			$Arrow.show()
		SET_AIM:
			$Arrow.transform.origin = $Ball.transform.origin
			$Arrow.show()
			#set_start_angle2()
		SET_POWER:
			pass
		SHOOT:
			$Arrow.hide()
			$Ball.shoot($Arrow.rotation.y, power)
		WIN:
			$Ball.hide()
			$Arrow.hide()

func animate_power_bar(delta):
	power += power_speed * power_dir * delta
	if power >= 100:
		power_dir = -1
	if power <= 0:
		power_dir = 1
	$CanvasLayer/TextureProgress.value = power

func animate_aim(delta):
	$Arrow.rotation.y += aim_speed * aim_dir * delta
	if $Arrow.rotation.y > hole_dir + PI/2:
		aim_dir = -1
	if $Arrow.rotation.y < hole_dir - PI/2:
		aim_dir = 1

func _input(event):
	if event is InputEventMouseMotion:
		if state == SET_AIM:
			$Arrow.rotation.y -= event.relative.x / 100
	if event.is_action_pressed('ui_select'):
		match state:
			SET_AIM:
				change_state(SET_POWER)
			SET_POWER:
				change_state(SHOOT)

func _process(delta):
	$GimbalOut.transform.origin = $Ball.transform.origin
	match state:
#		SET_AIM:
#			pass
#			#animate_aim(delta)
		SET_POWER:
			animate_power_bar(delta)
		SHOOT:
			pass

func _on_Hole_body_entered(body):
	print("Hole!")
	change_state(WIN)


func _on_Ball_stopped():
	if state == SHOOT:
		change_state(SET_AIM)

func _on_Cam2Vis_body_entered(body):
	$Camera2.current = true

func _on_Cam3Vis_body_entered(body):
	$Camera3.current = true
