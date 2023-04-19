extends Area2D

@onready var attack_cooldown: Timer = get_node("AttackCooldown")

# health related stats
@export var max_health: int = 10
@export var health: int = 10

# utility related stats
@export var attack_range: int = 300
@export var movement_speed: int = 400

# damage related stats
@export var damage: int = 3

#exp related stats
@export var level = 1


func _ready():
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# collision with player
func _on_area_entered(area):
	if area.is_in_group("player") and attack_cooldown.is_stopped():
		attack(area)

# collision with bullet, only damage is computed
func _on_body_entered(body):
	got_hit(body.damage)

# implements the damage, but any animation
# must be implemented for each enemy
func got_hit(damage):
	health -= damage

func attack(player):
	player.got_hit(damage)
	attack_cooldown.start()



func _on_target_change_timeout():
	pass # Replace with function body.
