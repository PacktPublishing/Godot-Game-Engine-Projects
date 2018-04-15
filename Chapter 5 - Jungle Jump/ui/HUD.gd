extends MarginContainer

onready var life_counter = [$HBoxContainer/LifeCounter/L1,
							$HBoxContainer/LifeCounter/L2,
							$HBoxContainer/LifeCounter/L3,
							$HBoxContainer/LifeCounter/L4,
							$HBoxContainer/LifeCounter/L5]

func _on_Player_life_changed(value):
	for heart in range(life_counter.size()):
		life_counter[heart].visible = value > heart

func _on_score_changed(value):
	$HBoxContainer/ScoreLabel.text = str(value)