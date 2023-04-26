extends base_range_weapon


func _process(_delta):
	nearest_enemy = find_nearest_enemy()
	if nearest_enemy:
		rotate_weapon(nearest_enemy)

func fire():
	# if can_fire is off or there are no enemies left dont shoot
	if !can_fire:
		return
	if get_tree().get_nodes_in_group("enemy").size() <= 0:
		return
	# instantiate a new Bullet and set its position and rotation.
	var bullet_instance = bullet.instantiate()
	bullet_instance.init(calculate_damage())
	bullet_instance.position = $GunPoint.global_position
	bullet_instance.rotation = $GunPoint.global_rotation
	bullet_instance.point_of_origin = bullet_instance.position
	bullet_instance.add_to_group("bullet")
	# apply force to it and play the muzzle flash anim
	bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated($GunPoint.global_rotation))
	muzzleFlashAnim.play("muzzle_flash")
	# add it to the scene tree
	get_tree().get_root().add_child(bullet_instance)
	super.fire()
	
