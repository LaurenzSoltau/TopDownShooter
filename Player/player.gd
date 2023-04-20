extends Area2D

var game_running = false
var screen_size
var direction
var velocity = Vector2.ZERO
var starting_position = Vector2.ZERO
var weapons = []

var player_stats:Resource



# Called when the node enters the scene tree for the first time.
func _ready():
	player_stats = null
	player_stats = load("res://Assets/Resources/player_stats.tres")
	player_stats.connect("stat_changed", stat_changed)
	screen_size = get_viewport_rect().size
	start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !game_running:
		return
	
	handle_movement(delta)
	# check if player is dead
	
	if player_stats.stats["health"] <= 0:
		die()
		


func stat_changed(stats):
	print_debug(stats["xp"])
	if player_stats["xp"] >= player_stats["xp_needed"]:
		# level up logic
		pass
	
	
	
func got_hit(damage):
	player_stats.add_stat("health", -damage)
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.modulate = Color(1, 1, 1)


func stop():
	position = starting_position
	velocity = Vector2.ZERO
	$AnimatedSprite2D.animation = "idle"
	game_running = false
	stop_all_weapons(weapons)
	
func start():
	var pistole = WeaponScenes.weapons["pistole_1"].instantiate()
	var machine_gun = WeaponScenes.weapons["machinegun_1"].instantiate()
	add_weapon(pistole)
	add_weapon(machine_gun)
	$AnimatedSprite2D.play()
	game_running = true
	start_all_weapons(weapons)
	player_stats.stats["health"] = 10
	show()


func handle_movement(delta):
	direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	direction = direction.normalized()
	velocity = direction * player_stats.stats["movement_speed"]
	position += velocity * delta
	position.x = clamp(position.x, -990, 990)
	position.y = clamp(position.y, -990, 920)
	
	# handles animation of the player
	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
	else:
		$AnimatedSprite2D.animation = "idle"
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false


# function that adds a weapon to the weapon array if there is space
# also adds the weapon to the weapons node as a child
func add_weapon(weapon):
	if weapons.size() >= 3:
		print_debug("Waffen sind Voll")
		return
	weapon.position = get_node("weapons/GunPositions").get_child(weapons.size()).position*20
	weapons.append(weapon)
	$weapons.add_child(weapon)


#function that removes a weapon at a index
func remove_weapon(index):
	if weapons.size() <= 0:
		print_debug("No Weapons to remove")
		return
	$weapons.remove_child(weapons[index])
	weapons.remove_at(index)

# function that stops the shootingTimer on all weapons
func stop_all_weapons(_weapons):
	for weapon in _weapons:
		weapon.get_child(3).stop()

# function that starts the shootingTimer on all weapons
func start_all_weapons(_weapons):
	for weapon in _weapons:
		weapon.get_child(3).start()


func die():
	get_tree().change_scene_to_file("res://Screens/end_screen.tscn")
	stop()
	get_parent().game_over()
