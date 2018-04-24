# Use this on the Player scene for click-to-move
# using TouchScreen events.
extends Area2D

signal pickup
signal hurt

export (int) var speed = 200
var velocity = Vector2()
var target = Vector2()
var screensize = Vector2(480, 720)

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position

func _process(delta):
	velocity = (target - position).normalized() * speed

	if (target - position).length() > 5:
		position += velocity * delta
	else:
		velocity = Vector2()
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)

	if velocity.length() > 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.animation = "idle"

func start(pos):
	set_process(true)
	position = pos
	$AnimatedSprite.animation = "idle"

func die():
	$AnimatedSprite.animation = "hurt"
	set_process(false)

func _on_Player_area_entered( area ):
	if area.is_in_group("coins"):
		area.pickup()
		emit_signal("pickup", "coin")
	if area.is_in_group("powerups"):
		area.pickup()
		emit_signal("pickup", "powerup")
	if area.is_in_group("obstacles"):
		emit_signal("hurt")
		die()