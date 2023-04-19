extends Node2D


@export var enemy: PackedScene
@onready var spawn_timer = $SpawnTimer

var enemies_remaining_to_spawn

var waves # array of all the Waves
var current_wave: Wave
var current_wave_number = -1
var isSpawning = false

func _ready():
	waves = $Waves.get_children()

func start_next_wave():
	current_wave_number += 1
	print("current Wave: ", current_wave_number)
	current_wave = waves[current_wave_number]
	enemies_remaining_to_spawn = current_wave.num_enemies
	spawn_timer.wait_time = current_wave.second_between_spawns
	spawn_timer.start()
	
	
func spawn_enemy():
	var mob = enemy.instantiate()
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("../MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Spawn the mob by adding it to the Main scene.
	get_parent().add_child(mob)

func _on_spawn_timer_timeout():
	if enemies_remaining_to_spawn and isSpawning:
		spawn_enemy()
		enemies_remaining_to_spawn -= 1
		

func check_if_enemies_are_in_root_scene():
	var enemies = get_tree().get_nodes_in_group("enemy") 
	if enemies.size() - 1 < 1:
		await get_tree().create_timer(2).timeout
		start_next_wave()
	
