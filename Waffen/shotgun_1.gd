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
	
	for bullet in bullet_instances:
		bullet.init(calculate_damage())
		bullet.position = $GunPoint.global_position
		bullet.rotation = $GunPoint.global_rotation + deg_to_rad(spread_degree)
		bullet.point_of_origin = bullet.position
		bullet.add_to_group("bullet")
		bullet.apply_impulse(Vector2(bullet_speed, 0).rotated($GunPoint.global_rotation + deg_to_rad(spread_degree)))
		muzzleFlashAnim.play("muzzle_flash")
		get_tree().get_root().add_child(bullet)
		super.fire()
		spread_degree += 2
