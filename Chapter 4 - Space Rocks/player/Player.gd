extends RigidBody2D

signal shoot
signal lives_changed
signal shield_changed
signal dead

export (int) var max_shield
export (float) var shield_regen
export (int) var engine_thrust
export (int) var spin_thrust
export (int) var invuln_time
export (float) var fire_rate
export (PackedScene) var Bullet

enum {INIT, ALIVE, INVULNERABLE, DEAD}
var state = null
var thrust = Vector2()
var rotation_dir = 0
var can_shoot = true
var active_guns = []
var screensize = Vector2()
var lives = 0 setget set_lives
var shield = 0 setget set_shield

func _ready():
	active_guns = [$GunCenter]
	change_state(INIT)
	$GunTimer.wait_time = fire_rate

func start():
	$Sprite.show()
	self.lives = 3
	change_state(ALIVE)
	self.shield = max_shield

func set_lives(value):
	lives = value
	self.shield = max_shield
	emit_signal("lives_changed", lives)
	if lives <= 0:
		change_state(DEAD)
	else:
		change_state(INVULNERABLE)

func set_shield(value):
	if value > max_shield:
		value = max_shield
	shield = value
	emit_signal("shield_changed", shield/max_shield)
	if shield <= 0:
		self.lives -= 1

func shoot():
	if state == INVULNERABLE:
		return
	for gun in active_guns:
		emit_signal("shoot", Bullet, gun.global_position, rotation + gun.rotation)
	can_shoot = false
	$GunTimer.start()
	$LaserSound.play()

func get_input():
	thrust = Vector2()
	$Exhaust.emitting = false
	if state in [DEAD, INIT]:
		return
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
	if Input.is_action_pressed("thrust"):
		thrust = Vector2(engine_thrust, 0)
		$Exhaust.emitting = true
		if not $EngineSound.playing:
			$EngineSound.play()
	else:
		$EngineSound.stop()
	rotation_dir = 0
	if Input.is_action_pressed("rotate_right"):
		rotation_dir += 1
	if Input.is_action_pressed("rotate_left"):
		rotation_dir -= 1

func _process(delta):
	get_input()
	self.shield += shield_regen * delta

func _integrate_forces(physics_state):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(rotation_dir * spin_thrust)
	var xform = physics_state.get_transform()
	if state == INIT:
		xform = Transform2D(0, screensize/2)
	if xform.origin.x > screensize.x:
		xform.origin.x = 0
	if xform.origin.x < 0:
		xform.origin.x = screensize.x
	if xform.origin.y > screensize.y:
		xform.origin.y = 0
	if xform.origin.y < 0:
		xform.origin.y = screensize.y
	physics_state.set_transform(xform)

func change_state(new_state):
	state = new_state
	print("changing state to ", state)
	match state:
		INIT:
			$CollisionShape2D.disabled = true
			$Sprite.modulate.a = 0.5
		ALIVE:
			$CollisionShape2D.disabled = false
			$Sprite.modulate.a = 1.0
		INVULNERABLE:
			$CollisionShape2D.disabled = true
			$Sprite.modulate.a = 0.5
			$InvulnerabilityTimer.start()
		DEAD:
			$EngineSound.stop()
			$CollisionShape2D.disabled = true
			$Sprite.hide()
			linear_velocity = Vector2()
			emit_signal("dead")

func _on_GunTimer_timeout():
	can_shoot = true

func _on_InvulnerabilityTimer_timeout():
	change_state(ALIVE)

func _on_Player_body_entered( body ):
	if body.is_in_group('rocks'):
		body.explode()
		$Explosion.show()
		$Explosion/AnimationPlayer.play("explosion")
		self.shield -= body.size * 25

func _on_AnimationPlayer_animation_finished( name ):
	$Explosion.hide()
