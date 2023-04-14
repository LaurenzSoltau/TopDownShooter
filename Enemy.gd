extends CharacterBody2D

var speed = 200
var health = 10

@export var p: CharacterBody2D

func _process(_delta):
	velocity = position.direction_to(p.position) * speed
	move_and_slide()
	
	if health <= 0:
		queue_free()

func got_hit(damage):
	health -= damage

	
