extends ColorRect


var stat_elements = []

var player_inventory: Resource
var player_stats: Resource
@onready var stats = get_node("VBoxContainer").get_child(0).get_child(0).get_child(1)
@onready var char = get_node("VBoxContainer").get_child(0).get_child(0).get_child(0)
@onready var inventory = get_node("VBoxContainer").get_child(1).get_child(0).get_child(0).get_child(0)
@onready var weapon_stats = get_node("VBoxContainer").get_child(1).get_child(0).get_child(0).get_child(1)


func _ready():
	player_inventory = null
	player_inventory = load("res://Assets/Resources/player_inventory.tres")
	player_inventory.connect("weapon_added", update_weapons)
	player_stats = null
	player_stats = load("res://Assets/Resources/player_stats.tres")
	player_stats.connect("stat_changed", update_stats)
	for child in stats.get_child(1).get_children():
		stat_elements.append(child)
	for child in stats.get_child(2).get_children():
		stat_elements.append(child)
	update_stats(player_stats.stats)


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

func update_weapons():
	for i in player_inventory.weapons.size():
		var weapon_panel
		if i <= 4:
			weapon_panel = inventory.get_child(0).get_child(0).get_child(1).get_child(i)
			weapon_panel.load_panel(player_inventory.weapons[i])
		else:
			weapon_panel = inventory.get_child(0).get_child(0).get_child(2).get_child(i)
	
