extends Node

func _ready():
	# make sure level numbers are 2 digits ("01", etc.)
	var level_num = str(GameState.current_level).pad_zeros(2)
	var path = 'res://levels/Level%s.tscn' % level_num
	var map = load(path).instance()
	add_child(map)
