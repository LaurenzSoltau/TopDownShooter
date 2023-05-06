extends Sprite2D
# the base for all range firing weapons in the game
# from this scene all other range weapons inherit
class_name base_range_weapon




@export var fire_rate: float
@export var bullet_damage: float
@export var bullet_speed: int
@export var weapon_range: int
@export var price: int
var purchase_price: int




@export var bullet: PackedScene
@onready var shootTimer: Timer = $ShootTimer
@onready var muzzleFlashAnim: AnimationPlayer = $AnimationPlayer
@onready var gunShotSound: AudioStreamPlayer2D = $gunShot
var player_stats
var weapon_stats


var nearest_enemy
var can_fire = true
var angle = rotation

func _ready():
	player_stats = null
	player_stats = load("res://Assets/Resources/player_stats.tres")
	shootTimer.wait_time = fire_rate
	weapon_stats = {
		"fire_rate": fire_rate,
		"bullet_damage": bullet_damage,
		"bullet_speed": bullet_speed,
		"weapon_range": weapon_range,
	}
# This function should shoot the gun and must be implemented in the inhereted classes
func fire():
	#only shoot wehen enemy is in distance
	gunShotSound.play()

func stop():
	shootTimer.stop()
# this function finds the nearest enemy to the weapon and retuns the enemy as an object
func find_nearest_enemy():
	# check if there are enemies instanced, if not return
	if get_tree().get_nodes_in_group("enemy").size() <= 0:
		return null
	# get all enemies and find the nearest one
	var enemies = get_tree().get_nodes_in_group("enemy")
	var nearest = enemies[0]
	for enemy in enemies:
		# compare distances and switch if its smaller
		if global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest.global_position):
			nearest = enemy
	return nearest
	

func _on_shoot_timer_timeout():
	fire()

# function make the weapon look at the enemy passed in and rotates it accordingly
func rotate_weapon(enemy):
	if enemy:
		look_at(enemy.global_position)
		angle = global_position.angle_to_point(enemy.global_position)
	# flip the weapon if enemy on left side of it and otherway around
	if abs(angle) > PI  / 2:
		scale.y = -0.45
	else:
		scale.y = 0.45

func calculate_damage():
	# calculating damage by adding bullet damage to range damage and add damage percent
	var total_damage: float = round((bullet_damage + player_stats.stats["range_damage"]) * (1 + player_stats.stats["damage_percent"] / 100.0))
	return total_damage

func enemy_is_in_range():
	if nearest_enemy:
		return global_position.distance_to(nearest_enemy.global_position) <= weapon_range + player_stats.stats["attack_range"]
	return false
