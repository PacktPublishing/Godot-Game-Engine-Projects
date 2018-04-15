extends CanvasLayer

var bar_red = preload("res://assets/bar_red.png")
var bar_green = preload("res://assets/bar_green.png")
var bar_yellow = preload("res://assets/bar_yellow.png")

func update_shots(value):
	$Margin/Container/Shots.text = 'Shots: %s' % value

func update_powerbar(value):
	$Margin/Container/PowerBar.texture_progress = bar_green
	if value > 70:
		$Margin/Container/PowerBar.texture_progress = bar_red
	elif value > 40:
		$Margin/Container/PowerBar.texture_progress = bar_yellow
	$Margin/Container/PowerBar.value = value