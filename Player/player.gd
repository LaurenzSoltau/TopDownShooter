extends Area2D

var game_running = false
var screen_size
var direction
var velocity = Vector2.ZERO
var starting_position = Vector2.ZERO
var is_hit = false
var weapon_slots: int

var player_stats: Resource
var player_inventory: Resource

signal level_up


# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_slots = $weapons.get_child(0).get_children().size()
	# load resources
	player_inventory = null
	player_inventory = load("res://Assets/Resources/player_inventory.tres")
	player_inventory.connect("weapon_added", added_weapon)
	player_inventory.connect("weapon_removed", removed_weapon)
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
	if stats["xp"] >= stats["xp_needed"]:
		var xp_after_level_up = int(stats["xp"]) % int(stats["xp_needed"])
		var xp_needed_after_level_up = stats["xp_needed"] * 1.1
		player_stats.add_stat("level", 1, false)
		player_stats.set_stat("xp", xp_after_level_up, false)
		player_stats.set_stat("xp_needed", xp_needed_after_level_up, true)
		#muss noch geändert werden
		print_debug("Muss noch verbessert werden nur vorläufiger Code")
		await get_tree().create_timer(0.5).timeout
		get_node("../HUD/UserInterface/UpgradeOverlay").new_shop()
		get_tree().paused = true
	
	
	
func got_hit(damage):
	if !game_running:
		return
	player_stats.add_stat("health", -damage, true)
	$AnimatedSprite2D.modulate = Color(1, 0, 0)
	$AnimatedSprite2D.animation = "hit"
	is_hit = true
	await get_tree().create_timer(0.2).timeout
	is_hit = false
	$AnimatedSprite2D.modulate = Color(1, 1, 1)


func start():
	var pistole = WeaponScenes.weapons[0]["scene"].instantiate()
	player_inventory.add_weapon(pistole)
	$AnimatedSprite2D.play()
	game_running = true
	player_stats.stats["health"] = 10
	show()

func stop():
	position = starting_position
	velocity = Vector2.ZERO
	game_running = false


func handle_movement(delta):
	direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	direction = direction.normalized()
	velocity = direction * player_stats.stats["movement_speed"]
	position += velocity * delta
	position.x = clamp(position.x, -920, 920)
	position.y = clamp(position.y, -820, 900)
	
	# handles animation of the player
	if is_hit:
		return
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
func added_weapon(weapon):
	var child_pos = player_inventory.weapons.size()-1
	weapon.position = get_node("weapons/GunPositions").get_child(child_pos).position*20
	$weapons.add_child(weapon)


#function that removes a weapon at a index
func removed_weapon(index):
	$weapons.remove_child(player_inventory.weapons[index])


func die():
	game_running = false
	player_inventory.stop_all_weapons()
	$AnimatedSprite2D.animation = "die"
	$AnimatedSprite2D.play()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Screens/end_screen.tscn")
	stop()
	get_parent().game_over()


func _on_health_timer_timeout():
	if player_stats.stats["health"] < player_stats.stats["max_health"]:
		player_stats.add_stat("health", player_stats.stats["health_regen"] / 10, true)




