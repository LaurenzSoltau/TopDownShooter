extends CommonEnemy

@export var bullet: PackedScene

func got_hit(pDamage):
	health -= pDamage


func move_towards_target(delta):
	var velocity = position.direction_to(current_target) * movement_speed
	# if enemy is far away, move towards target
	if position.distance_to(current_target) > 450 or is_dying:
		position += velocity * delta
	# if enemy is close, move away from target
	else:
		current_target = position - position.direction_to(player_node.position) * 800
		$TargetChange.wait_time = 3
		print("new target")
		
	# stay in map
	position.x = clamp(position.x, -990, 990)
	position.y = clamp(position.y, -990, 920)
	
	# change the animation in relation to the direction the object ist running
	if velocity.x != 0 or velocity.y != 0:
		animated_sprite.animation = "walk"
		animated_sprite.play()
	if velocity.x < 0:
		animated_sprite.flip_h = true
	if velocity.x > 0:
		animated_sprite.flip_h = false


func get_target():
	return player_node.position

func die():
	var xp_instance = xp_drop.instantiate()
	xp_instance.global_position = position
	get_tree().current_scene.add_child(xp_instance)
	super.die()


func _on_shoot_timer_timeout():
	if player_node.position.distance_to(position) > attack_range:
		return
	# instantiate a new Bullet and set its position and rotation.
	var bullet_instance = bullet.instantiate()
	bullet_instance.damage = damage
	bullet_instance.position = global_position
	# apply force to it and play the muzzle flash anim
	bullet_instance.velocity = global_position.direction_to(player_node.global_position) * 400
	# add it to the scene tree
	get_tree().get_root().add_child(bullet_instance)
