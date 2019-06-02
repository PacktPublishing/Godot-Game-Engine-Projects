extends Area2D

signal shoot

export(PackedScene) var Bullet
export (int) var speed
export (int) var health

var follow
var target = null

func _ready():
	$Sprite.frame = randi() % 3
	var path = $EnemyPaths.get_children()[randi() % $EnemyPaths.get_child_count()]
	follow = PathFollow2D.new()
	path.add_child(follow)
	follow.loop = false

func _process(delta):
	follow.offset += speed * delta
	position = follow.global_position
	if follow.unit_offset > 1:
		queue_free()

func shoot():
	var dir = target.global_position - global_position
	dir = dir.rotated(rand_range(-0.1, 0.1)).angle()
	$ShootSound.play()
	emit_signal('shoot', Bullet, global_position, dir)

func shoot_pulse(n, delay):
	for i in range(n):
		shoot()
		yield(get_tree().create_timer(delay), 'timeout')

func take_damage(amount):
	health -= amount
	$AnimationPlayer.play('flash')
	if health <= 0:
		explode()
	yield($AnimationPlayer, 'animation_finished')
	$AnimationPlayer.play('rotate')

func explode():
	speed = 0
	$GunTimer.stop()
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Sprite.hide()
	$Explosion.show()
	$Explosion/AnimationPlayer.play("explosion")
	$ExplodeSound.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

func _on_GunTimer_timeout():
	shoot_pulse(2, 0.15)

func _on_Enemy_body_entered(body):
	if body.name == 'Player':
		body.shield -= 50
		explode()
