extends Node2D

signal score_changed

var Collectible = preload('res://items/Collectible.tscn')
onready var pickups = $Pickups
onready var HUD = $CanvasLayer/HUD
var score

func _ready():
	$Player.connect('life_changed', $CanvasLayer/HUD, '_on_Player_life_changed')
	$Player.connect('dead', self, '_on_Player_dead')
	connect('score_changed', $CanvasLayer/HUD, '_on_score_changed')
	score = 0
	emit_signal('score_changed', score)
	pickups.hide()
	$Player.start($PlayerSpawn.position)
	set_camera_limits()
	spawn_pickups()

func set_camera_limits():
	var map_size = $World.get_used_rect()
	var cell_size = $World.cell_size
	$Player/Camera2D.limit_left = (map_size.position.x - 5) * cell_size.x
	$Player/Camera2D.limit_right = (map_size.end.x + 5) * cell_size.x

func spawn_pickups():
	for cell in pickups.get_used_cells():
		var id = pickups.get_cellv(cell)
		var type = pickups.tile_set.tile_get_name(id)
		if type in ['gem', 'cherry']:
			var c = Collectible.instance()
			var pos = pickups.map_to_world(cell)
			c.init(type, pos + pickups.cell_size/2)
			add_child(c)
			c.connect('pickup', self, '_on_Collectible_pickup')

func _on_Collectible_pickup():
	$PickupSound.play()
	score += 1
	emit_signal('score_changed', score)

func _on_Player_dead():
	GameState.restart()

func _on_Door_body_entered(body):
	GameState.next_level()

func _on_Ladder_body_entered(body):
	if body.name == "Player":
		body.is_on_ladder = true

func _on_Ladder_body_exited(body):
	if body.name == "Player":
		body.is_on_ladder = false