extends ColorRect


var stat_elements = []

var player_inventory: Resource

@onready var stats = get_node("VBoxContainer").get_child(0).get_child(0).get_child(1)
@onready var char = get_node("VBoxContainer").get_child(0).get_child(0).get_child(0)
@onready var inventory = get_node("VBoxContainer").get_child(1).get_child(0).get_child(0).get_child(0)
@onready var weapon_stats = get_node("VBoxContainer").get_child(1).get_child(0).get_child(0).get_child(1)
@onready var player_stats: Resource = null
var weapon_stat_elements = []
var sell_weapon_button: Button
var selected_weapon: base_range_weapon

func _ready():
	# load all weapon stat elements in one array
	for element in weapon_stats.get_child(1).get_children():
		weapon_stat_elements.append(element)
	for element in weapon_stats.get_child(2).get_children():
		weapon_stat_elements.append(element)
	# load in Resources
	player_inventory = null
	player_inventory = load("res://Assets/Resources/player_inventory.tres")
	player_inventory.connect("weapon_added", update_weapons)
	player_stats = load("res://Assets/Resources/player_stats.tres")
	player_stats.connect("stat_changed", update_stats)
	for child in stats.get_child(1).get_children():
		stat_elements.append(child)
	for child in stats.get_child(2).get_children():
		stat_elements.append(child)
	update_stats(player_stats.stats)
	sell_weapon_button = weapon_stats.get_child(4)


func load():
	get_parent().play_slide_sound()
	$AnimationPlayer.current_animation = "SlideIn"
	$AnimationPlayer.play()
	get_tree().paused = true

func deload():
	get_parent().play_slide_sound()
	$AnimationPlayer.current_animation = "SlideOut"
	$AnimationPlayer.play()
	get_tree().paused = false

func update_stats(_stats):
	for stat in stat_elements:
		if stat.stat_key == null:
			return
		if stat.stat_key in _stats:
			stat.change_value(_stats[stat.stat_key])

func update_weapons(_weapon):
	for i in 8:
		var weapon_panel
		if i <= 3:
			weapon_panel = inventory.get_child(0).get_child(0).get_child(1).get_child(i)
		else:
			weapon_panel = inventory.get_child(0).get_child(0).get_child(2).get_child(i % 4)
		if i < player_inventory.weapons.size():
			weapon_panel.load_panel(player_inventory.weapons[i])
		else:
			weapon_panel.unload_panel()

func update_weapon_stats(index):
	weapon_stats.get_child(4).show()
	if weapon_stats.get_child(0).visible:
		weapon_stats.get_child(0).visible = false
	if player_inventory.weapons[index] == selected_weapon:
		GlobalSound.play_ui_error()
		return
	GlobalSound.play_ui_sound()
	selected_weapon = player_inventory.weapons[index]
	weapon_stats.get_child(1).text = selected_weapon.name
	sell_weapon_button.text = "Sell for %s$" % str(int(selected_weapon.purchase_price / 2))
	var i = 0
	for stat in selected_weapon.weapon_stats:
		weapon_stat_elements[i].change_value(stat, selected_weapon.weapon_stats[stat])
		i += 1

func reset_weapon_stats():
	weapon_stats.get_child(4).hide()
	weapon_stats.get_child(0).show()
	for element in weapon_stat_elements:
		element.change_value("", "")
		weapon_stats.get_child(0).visible
	weapon_stats.get_child(1).text = "Weapon Stats"

func sell_weapon():
	if selected_weapon == null:
		GlobalSound.play_ui_error()
		return
	GlobalSound.play_ui_sound()
	player_stats.add_stat("money", int(selected_weapon.purchase_price / 2), true)
	player_inventory.remove_weapon_by_name(selected_weapon)
	selected_weapon = null
	update_weapons(1)
	reset_weapon_stats()
	
