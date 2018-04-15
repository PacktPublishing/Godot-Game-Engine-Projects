extends Area2D

signal pickup

var textures = {'cherry': 'res://assets/sprites/cherry.png',
				'gem': 'res://assets/sprites/gem.png'}

func init(type, pos):
	$Sprite.texture = load(textures[type])
	position = pos

func _on_Collectible_body_entered(body):
	emit_signal('pickup')
	queue_free()
