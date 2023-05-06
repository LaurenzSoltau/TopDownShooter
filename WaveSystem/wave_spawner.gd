extends Node2D


@export var enemy1: PackedScene
@export var enemy2: PackedScene
@export var enemy3: PackedScene
@export var enemy4: PackedScene
@export var enemy5: PackedScene

signal new_wave

@onready var spawn_timer = $SpawnTimer

var waves # array of all the Waves
var current_wave: Wave
var current_wave_number = -1
var isSpawning = false
var enemy_scenes = []

func _ready():
	waves = $Waves.get_children()
	enemy_scenes.append(enemy1)
	enemy_scenes.append(enemy2)
	enemy_scenes.append(enemy3)
	enemy_scenes.append(enemy4)
	enemy_scenes.append(enemy5)

func start_next_wave():
	current_wave_number += 1
	emit_signal("new_wave", current_wave_number)
	print_debug("current Wave: ", current_wave_number)
	current_wave = waves[current_wave_number]
	spawn_timer.wait_time = current_wave.second_between_spawns
	spawn_timer.start()
	
	
func spawn_enemy():
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("../MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	if current_wave.type_code.is_empty():
		spawn_timer.stop()
		return
	var type_code_index = randi() % current_wave.type_code.size()
	var enemy_to_spawn = enemy_scenes[current_wave.type_code[type_code_index]].instantiate()
	current_wave.type_code.remove_at(type_code_index)
	
	enemy_to_spawn.global_position = mob_spawn_location.global_position


	# Spawn the mob by adding it to the Main scene.
	get_parent().add_child(enemy_to_spawn)

func _on_spawn_timer_timeout():
	if isSpawning:
		spawn_enemy()
		

func check_if_enemies_are_in_root_scene():
	var enemies = get_tree().get_nodes_in_group("enemy") 
	if enemies.size() - 1 < 1:
		await get_tree().create_timer(2).timeout
		start_next_wave()
	
