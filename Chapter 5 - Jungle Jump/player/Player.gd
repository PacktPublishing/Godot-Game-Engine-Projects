extends KinematicBody2D

signal life_changed
signal dead

export (int) var run_speed
export (int) var jump_speed
export (int) var gravity
export (int) var climb_speed

enum {IDLE, RUN, JUMP, HURT, DEAD, CROUCH, CLIMB}
var state
var anim
var new_anim
var velocity = Vector2()
var life
var max_jumps = 2
var jump_count = 0
var is_on_ladder = false

func _ready():
	change_state(IDLE)

func start(pos):
	position = pos
	show()
	life = 3
	emit_signal('life_changed', life)
	change_state(IDLE)

func change_state(new_state):
	state = new_state
	# print("changing to ", state)
	match state:
		IDLE:
			new_anim = 'idle'
		RUN:
			new_anim = 'run'
		CROUCH:
			new_anim = 'crouch'
		HURT:
			new_anim = 'hurt'
			velocity.y = -200
			velocity.x = -100 * sign(velocity.x)
			life -= 1
			emit_signal('life_changed', life)
			yield(get_tree().create_timer(0.5), 'timeout')
			change_state(IDLE)
			if life <= 0:
				change_state(DEAD)
		JUMP:
			new_anim = 'jump_up'
			jump_count = 1
		CLIMB:
			new_anim = 'climb'
		DEAD:
			hide()
			emit_signal('dead')

func get_input():
	if state == HURT:
    	return
	velocity.x = 0
	var right = Input.is_action_pressed('right')
	var left = Input.is_action_pressed('left')
	var jump = Input.is_action_just_pressed('jump')
	var down = Input.is_action_pressed('crouch')
	var climb = Input.is_action_pressed('climb')

	if climb and state != CLIMB and is_on_ladder:
		change_state(CLIMB)
	if state == CLIMB:
		if climb:
			velocity.y = -climb_speed
		elif down:
			velocity.y = climb_speed
		else:
			velocity.y = 0
			$AnimationPlayer.play("climb")
	if state == CLIMB and not is_on_ladder:
		change_state(IDLE)
	if down and is_on_floor():
		change_state(CROUCH)
	if !down and state == CROUCH:
		change_state(IDLE)
	if right:
		velocity.x += run_speed
		$Sprite.flip_h = false
	if left:
		velocity.x -= run_speed
		$Sprite.flip_h = true
	if jump and state == JUMP and jump_count < max_jumps:
		new_anim = 'jump_up'
		velocity.y = jump_speed / 1.5
		jump_count += 1
	if jump and is_on_floor():
		$JumpSound.play()
		change_state(JUMP)
		velocity.y = jump_speed
	if state in [IDLE, CROUCH] and velocity.x != 0:
		change_state(RUN)
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)

func _physics_process(delta):
	if state != CLIMB:
		velocity.y += gravity * delta
	get_input()
	if new_anim != anim:
		anim = new_anim
		$AnimationPlayer.play(anim)

	velocity = move_and_slide(velocity, Vector2(0, -1))
	if state == HURT:
		return
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name == 'Danger':
			hurt()
		if collision.collider.is_in_group('enemies'):
			var player_feet = (position + $CollisionShape2D.shape.extents).y
			if player_feet < collision.collider.position.y:
				collision.collider.take_damage()
				velocity.y = -200
			else:
				hurt()

	if state == JUMP and velocity.y > 0:
		new_anim = 'jump_down'
	if state == JUMP and is_on_floor():
		change_state(IDLE)
		$Dust.emitting = true
	if position.y > 1000:
		change_state(DEAD)

func hurt():
	if state != HURT:
		$HurtSound.play()
		change_state(HURT)