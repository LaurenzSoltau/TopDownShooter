extends Area2D

var speed
var health = 10
var current_target_velocity
var current_target
var enemies
var damage = 3
var velocity = Vector2.ZERO


@export var p: Area2D
	
func _ready():
	p = get_node("../Player")
	add_to_group("enemy")
	speed = randi() % 210 + 190
	current_target = get_target()

func _process(delta):
	if position.distance_to(current_target) < 5:
		current_target = get_target()
		
	velocity = position.direction_to(current_target) * speed
	position += velocity * delta
	

	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.play()
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	
	
	if health <= 0:
		die()

func got_hit(damage):
	health -= damage
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	$AnimatedSprite2D.stop()
	var tmp_speed = speed
	speed = 0
	await get_tree().create_timer(0.2).timeout
	speed = tmp_speed
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
	$AnimatedSprite2D.play()
	
func get_target():
	var i
	if position.distance_to(p.position) < 50:
		i = 5
	else:
		i = randi() % 10
	var target
	if i > 4:
		target = p.position + Vector2(randi_range(-100, 100), randi_range(-100, 100))
	else:
		var screen_size = get_viewport_rect().size
		target = Vector2(randi_range(50, screen_size.x), randi_range(50, screen_size.y))
	return target
	

func _on_target_change_timeout():
	current_target = get_target()
	$TargetChange.wait_time = randf_range(1.5, 3.5)

func die():
	get_parent().get_child(4).check_if_enemies_are_in_root_scene()
	get_parent().increase_score(1)
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("bullet"):
		got_hit(body.damage)
		body.queue_free()
		

func _on_area_entered(area):
	if area.is_in_group("player") and $AttackCooldown.is_stopped():
		print("Attack")
		area.got_hit(damage)
		$AttackCooldown.start()
		
