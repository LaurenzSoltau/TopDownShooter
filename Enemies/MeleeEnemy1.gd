extends CommonEnemy


func got_hit(pDamage):
	health -= pDamage
	
	# freeze when hitted
	if !is_stunned:
		is_stunned = true
		animated_sprite.modulate = Color(1, 0, 0)
		animated_sprite.stop()
		var tmp_speed = movement_speed
		movement_speed = movement_speed / 2.0
		await get_tree().create_timer(0.1).timeout
		movement_speed = tmp_speed
		animated_sprite.modulate = Color(1, 1, 1)
		animated_sprite.play()
		is_stunned = false


func move_towards_target(delta):
	var velocity = position.direction_to(current_target) * movement_speed
	position += velocity * delta
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
	var i
	if position.distance_to(player_node.position) < 50:
		i = 5
	else:
		i = randi() % 10
	var target
	if i > 4:
		target = player_node.position + Vector2(randi_range(-100, 100), randi_range(-100, 100))
	else:
		var screen_size = get_viewport_rect().size
		target = Vector2(randi_range(50, screen_size.x), randi_range(50, screen_size.y))
	return target
