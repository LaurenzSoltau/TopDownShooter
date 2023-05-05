extends ColorRect

var player: Node
@onready var item_containers = $HBoxContainer.get_children()
var player_stats
var price_multiplier: float

var shop_items: Array

func _ready():
	price_multiplier = 1
	player_stats = null
	player_stats = load("res://Assets/Resources/player_stats.tres")

func new_shop():
	if not $shopCooldown.is_stopped():
		return
	get_parent().play_slide_sound()
	$AnimationPlayer.current_animation = "SlideIn"
	$AnimationPlayer.play()
	shop_items = get_shop_items(3)
	assign_shop_items(shop_items)
	get_tree().paused = true
	player = get_node("/root/game/Player")

func close_shop():
	get_parent().play_slide_sound()
	$AnimationPlayer.current_animation = "SlideOut"
	$AnimationPlayer.play()
	get_tree().paused = false
	$shopCooldown.start()



func get_shop_items(amount):
	var created_weapons = []
	if amount > WeaponScenes.weapons.size():
		amount = WeaponScenes.weapons.size()
	for i in amount:
		var new_weapon
		var rand_int
		while (new_weapon in created_weapons or new_weapon == null):
			rand_int = randi() % WeaponScenes.weapons.size()
			new_weapon = WeaponScenes.weapons[rand_int]
		created_weapons.append(new_weapon)
	return created_weapons

func assign_shop_items(p_shop_items):
	print_debug(p_shop_items)
	var counter = 0
	for item in p_shop_items:
		var weapon_instance = item.scene.instantiate()
		var damage = weapon_instance.bullet_damage
		var attack_range = weapon_instance.fire_rate
		var speed = weapon_instance.bullet_speed
		var fire_rate = weapon_instance.fire_rate
		var vContainer = item_containers[counter].get_child(0).get_child(0)
		vContainer.get_child(0).text = item["name"]
		var desc = "Basedamage: %s\n Range: %s\n Firerate: %s\n Bulletspeed: %s" % [str(damage), str(attack_range), str(fire_rate), str(speed)]
		vContainer.get_child(1).text = desc
		vContainer.get_child(2).text = "%s$" % str(round(weapon_instance.price * price_multiplier))
		counter += 1

func weapon_bought(index):
	if index >= shop_items.size():
		print_debug("Kein Waffe implementiert")
		close_shop()
		return
	var weapon_instance = shop_items[index]["scene"].instantiate()
	if weapon_instance.price * price_multiplier > player_stats.stats["money"]:
		print_debug("zu teuer")
		return
	player.add_weapon(weapon_instance)
	player_stats.add_stat("money", -weapon_instance.price, true)
	price_multiplier = price_multiplier * 1.25
	close_shop()
	
