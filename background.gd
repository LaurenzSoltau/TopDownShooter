extends Sprite2D


@export var mob_scene: PackedScene
var starting_position = Vector2.ZERO

var score = 0

func game_over():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()
	$WaveSpawner.isSpawning = false
	$HUD.show_game_over()
	
func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$StartTimer.start()
	await get_tree().create_timer(2).timeout
	$Player.start()
	


func _on_start_timer_timeout():
	$WaveSpawner.isSpawning = true
	$WaveSpawner.start_next_wave()
	
func increase_score(_score):
	score += _score
	$HUD.update_score(score)
