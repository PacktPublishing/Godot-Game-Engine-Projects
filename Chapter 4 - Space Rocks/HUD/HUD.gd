extends CanvasLayer

signal start_game

onready var lives_counter = [$MarginContainer/HBoxContainer/LivesCounter/L1,
							 $MarginContainer/HBoxContainer/LivesCounter/L2,
							 $MarginContainer/HBoxContainer/LivesCounter/L3]
onready var ShieldBar = $MarginContainer/HBoxContainer/ShieldBar
var red_bar = preload("res://assets/barHorizontal_red_mid 200.png")
var green_bar = preload("res://assets/barHorizontal_green_mid 200.png")
var yellow_bar = preload("res://assets/barHorizontal_yellow_mid 200.png")


func show_message(message):
	$MessageLabel.text = message
	$MessageLabel.show()
	$MessageTimer.start()

func game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$StartButton.show()

func _on_MessageTimer_timeout():
	$MessageLabel.hide()
	$MessageLabel.text = ''

func update_score(value):
	$MarginContainer/HBoxContainer/ScoreLabel.text = str(value)

func update_shield(value):
	value *= 100
	ShieldBar.texture_progress = green_bar
	if value < 40:
		ShieldBar.texture_progress = red_bar
	elif value < 70:
		ShieldBar.texture_progress = yellow_bar
	ShieldBar.value = value

func update_lives(value):
	for item in range(3):
		lives_counter[item].visible = value > item

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")