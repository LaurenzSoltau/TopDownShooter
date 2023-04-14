extends CharacterBody2D

@export var speed = 400
var screen_size
var direction
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
	
	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
	else:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.play()
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
