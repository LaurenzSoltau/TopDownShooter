extends CharacterBody2D

var speed
var health = 10
var current_target_velocity
var current_target
var enemies

@export var p: CharacterBody2D
	
func _ready():
	p = get_node("../Player")
	add_to_group("enemy")
	speed = randi() % 210 + 190
	current_target = get_target()

func _process(_delta):
	if position.distance_to(current_target) < 5:
		current_target = get_target()
	velocity = position.direction_to(current_target) * speed
	move_and_slide()
		
	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.play()
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	
	
	if health <= 0:
		queue_free()

func got_hit(damage):
	health -= damage
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	$AnimatedSprite2D.stop()
	var tmp_speed = speed
	speed = 0
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
	speed = tmp_speed
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
