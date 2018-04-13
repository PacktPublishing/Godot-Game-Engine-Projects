extends CanvasLayer

func _ready():
	$MarginContainer/ScoreLabel.text = str(Global.score)

func update_score(value):
	Global.score += value
	$MarginContainer/ScoreLabel.text = str(Global.score)