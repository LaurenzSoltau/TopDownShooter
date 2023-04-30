extends CommonEnemy



func got_hit(pDamage):
	health -= pDamage
	
	# freeze when hitted
	freeze_on_hit(0.1)
	super.got_hit(pDamage)


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

func die():
	var xp_instance = xp_drop.instantiate()
	xp_instance.global_position = position
	get_tree().current_scene.add_child(xp_instance)
	super.die()
	
