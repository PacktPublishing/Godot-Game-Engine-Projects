extends Control

func _input(event):
	if event.is_action_pressed('ui_select'):
		get_tree().change_scene(GameState.game_scene)