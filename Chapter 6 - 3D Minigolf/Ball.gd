extends RigidBody

signal stopped

func shoot(angle, power):
	var force = Vector3(0, 0, -1).rotated(Vector3(0, 1, 0), angle)
	apply_impulse(Vector3(), force * power / 5)

func _integrate_forces(state):
	if state.linear_velocity.length() < 0.2:
		emit_signal("stopped")
		state.linear_velocity = Vector3()