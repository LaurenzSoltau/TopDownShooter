extends Area2D

class_name CommonEnemy


# health related stats
@export var max_health: int = 10
@export var health: int = 10

# utility related stats
@export var attack_range: int = 300
@export var movement_speed: int = 250

# damage related stats
@export var damage: int = 3

#exp related stats
@export var level: = 1
@export var money_worth: = 10
@export var exp_worth: = 10

var is_stunned: = false
var current_target
var player_stats
var player_node
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_cooldown: Timer = get_node("AttackCooldown")

func _ready():
	player_stats = null
	player_stats = load("res://Assets/Resources/player_stats.tres")
	player_node = get_node("../Player")
	add_to_group("enemy")
	# switch a movementspeed between the defined movementspeed - 10% and + 10%
	movement_speed = int(randf_range((movement_speed + movement_speed / 10.0), (movement_speed - movement_speed / 10.0)))
	current_target = get_target()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# make sure enemy always has an target
	if position.distance_to(current_target) < 5:
		current_target = get_target()
		
	move_towards_target(delta)
	if health <= 0:
		die()


# collision with player
func _on_area_entered(area):
	if area.is_in_group("player") and attack_cooldown.is_stopped():
		attack(area)

# collision with bullet, only damage is computed
func _on_body_entered(body):
	if body.is_in_group("bullet"):
		got_hit(body.damage)
		body.queue_free()

# must be implemented for each enemy
func got_hit(_pDamage):
	pass


func attack(player):
	player.got_hit(damage)
	attack_cooldown.start()


# changes the target when the timer runs out
func _on_target_change_timeout():
	current_target = get_target()
	$TargetChange.wait_time = randf_range(1.5, 2.5)


# finds a new target for the enemy to run towards
# must be implemented for each enemy type, because movement 
# differs between all enemy types
func get_target():
	pass


func move_towards_target(_delta):
	pass


# handles the freeing, but animation and similar must be implemented for each enemy
func die():
	player_stats.add_stat("money", money_worth, true)
	player_stats.add_stat("xp", exp_worth, true)
	get_node("../WaveSpawner").check_if_enemies_are_in_root_scene()
	queue_free()
