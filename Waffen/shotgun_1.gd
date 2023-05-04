extends base_range_weapon

func _process(_delta):
	nearest_enemy = find_nearest_enemy()
	if nearest_enemy:
		rotate_weapon(nearest_enemy)
		
func fire():
	if not nearest_enemy:
		return
	if not enemy_is_in_range():
		return
	if not can_fire:
		return
	if get_tree().get_nodes_in_group("enemy").size() <= 0:
		return
	
	var bullet_instances = []
	
	for i in 5:
		bullet_instances.append(bullet.instantiate())
	
	var spread_degree = -4
	
	for bullet_instance in bullet_instances:
		bullet_instance.init(calculate_damage())
		bullet_instance.position = $GunPoint.global_position
		bullet_instance.rotation = $GunPoint.global_rotation + deg_to_rad(spread_degree)
		bullet_instance.point_of_origin = bullet_instance.position
		bullet_instance.add_to_group("bullet")
		bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated($GunPoint.global_rotation + deg_to_rad(spread_degree)))
		muzzleFlashAnim.play("muzzle_flash")
		get_tree().get_root().add_child(bullet_instance)
		super.fire()
		spread_degree += 2
