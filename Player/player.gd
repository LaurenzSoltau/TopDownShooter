extends Area2D

var screen_size
var direction
var game_running = false
var velocity = Vector2.ZERO
var starting_position = Vector2.ZERO

var stats = {
	"health": 10,
	"health_regen": 0,
	"damage_percent": 0,
	"melee_damage": 0,
	"ranged_damage": 0,
	"crit_chance": 0,
	"movement_speed": 400,
	"armor": 0,
	"attack_speed_percent": 0,
	"range": 250,
	"xp-gain": 0,
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !game_running:
		return
	direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	direction = direction.normalized()
	velocity = direction * stats["movement_speed"]
	position += velocity * delta
	
	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
	else:
		$AnimatedSprite2D.animation = "idle"
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	if stats["health"] <= 0:
		stop()
		get_parent().game_over()
	
func got_hit(damage):
	stats["health"] -= damage
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.modulate = Color(1, 1, 1)

func stop():
	position = starting_position
	velocity = Vector2.ZERO
	$AnimatedSprite2D.animation = "idle"
	game_running = false
	$Weapon.get_child(3).stop()
	
func start():
	$AnimatedSprite2D.play()
	game_running = true
	$Weapon.get_child(3).start()
	stats["health"] = 10
	show()
