extends Sprite2D

var bullet_speed = 800
var fire_rate = 0.5

var can_fire = true

var bullet = preload("res://Player/bullet.tscn")
@onready var muzzleFlashAnim = $AnimationPlayer


func _process(delta):
	# gun points at cursor
	look_at(get_global_mouse_position())
	
	# calculate the angle in which the gun is aiming at the cursor
	rotation = fmod(rotation, 2*PI)
	var angle = global_position.angle_to_point(get_global_mouse_position())
	# flip the gun when necessery 
	if abs(angle) > PI / 2:
		scale.y = -0.55
	else:
		scale.y = 0.55
	
	if Input.is_action_pressed("fire") and can_fire:
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = $GunPoint.global_position
		bullet_instance.rotation = rotation
		
		bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated(rotation))
		muzzleFlashAnim.play("muzzle_flash")
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true
