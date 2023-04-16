extends Sprite2D

var bullet_speed = 2500
var fire_rate = 0.5

var can_fire = true
var angle = rotation

var bullet = preload("res://Player/bullet.tscn")
@onready var muzzleFlashAnim = $AnimationPlayer
var nearest_enemy
@onready var shooTimer = $ShootTimer


func _process(delta):
	# gun points at cursor
	if find_nearest_enemy():
		var enemy_position= find_nearest_enemy()
		look_at(enemy_position)
		angle = global_position.angle_to_point(enemy_position)

	# calculate the angle in which the gun is aiming at the cursor
	# flip the gun when necessery 
	if abs(angle) > PI  / 2:
		scale.y = -0.55
	else:
		scale.y = 0.55


func find_nearest_enemy():
	if get_tree().get_nodes_in_group("enemy").size() <= 0:
		return
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() < 1:
		return
	nearest_enemy = enemies[0]
	if enemies:
		for enemy in enemies:
			var current_distance = global_position.distance_to(nearest_enemy.global_position)
			var tmp_distance = global_position.distance_to(enemy.global_position)
			if tmp_distance < current_distance:
				nearest_enemy = enemy
	return nearest_enemy.global_position


func _on_shoot_timer_timeout():
	if get_tree().get_nodes_in_group("enemy").size() > 0:	
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = $GunPoint.global_position
		bullet_instance.rotation = $GunPoint.global_rotation
		bullet_instance.add_to_group("bullet")
		bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated($GunPoint.global_rotation))
		muzzleFlashAnim.play("muzzle_flash")
		get_tree().get_root().add_child(bullet_instance)
