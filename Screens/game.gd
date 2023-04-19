extends Sprite2D


@export var mob_scene: PackedScene
var starting_position = Vector2.ZERO


func _ready():
	new_game()


func game_over():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()
	$WaveSpawner.isSpawning = false


func new_game():
	$WaveSpawner.isSpawning = true
	$WaveSpawner.start_next_wave()


