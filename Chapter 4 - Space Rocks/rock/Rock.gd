extends RigidBody2D

signal explode

var screensize = Vector2()
var size
var radius
var scale_factor = 0.2

func start(_position, _velocity, _size):
	position = _position
	size = _size
	mass = 1.5 * size
	$Sprite.scale = Vector2(1, 1) * scale_factor * size
	$Explosion.scale = Vector2(.75, .75) * size
	radius = int($Sprite.texture.get_size().x * scale_factor * size / 2)
	var shape = CircleShape2D.new()
	shape.radius = radius
	var o = create_shape_owner(self)
	shape_owner_add_shape(o, shape)
	linear_velocity = _velocity
	angular_velocity = rand_range(-1.5, 1.5)

func _integrate_forces(physics_state):
	var xform = physics_state.get_transform()
	if xform.origin.x > screensize.x + radius:
		xform.origin.x = 0 - radius
	if xform.origin.x < 0 - radius:
		xform.origin.x = screensize.x + radius
	if xform.origin.y > screensize.y + radius:
		xform.origin.y = 0 - radius
	if xform.origin.y < 0 - radius:
		xform.origin.y = screensize.y + radius
	physics_state.set_transform(xform)

func explode():
	layers = 0
	$Sprite.hide()
	$Explosion.show()
	$Explosion/AnimationPlayer.play("explosion")
	$ExplodeSound.play()
	emit_signal('explode', size, radius, position, linear_velocity)
	linear_velocity = Vector2()
	angular_velocity = 0

func _on_Explosion_animation_finished():
	emit_signal('explode', size, radius, position, linear_velocity)
	queue_free()

func _on_AnimationPlayer_animation_finished( name ):
	queue_free()
