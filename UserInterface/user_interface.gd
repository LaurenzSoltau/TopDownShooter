extends Control

@onready var scene_tree: = get_tree()
@onready var pause_overlay: ColorRect = get_node("PauseOverlay")
@onready var score_label: Label = get_node("money")
@onready var hp_label: Label = get_node("hp_bar/hp")
@onready var hp_bar: ProgressBar = get_node("hp_bar")
@onready var xp_label: Label = get_node("xp_bar/level")
@onready var xp_bar: ProgressBar = get_node("xp_bar")
@onready var upgrade_overlay: ColorRect = get_node("Upgrade_Overlay")
var handle_input = true
var player_stats: Resource


var paused: = false:
	set(value):
		paused = on_pause_mode_change(value)

func _ready():
	player_stats = null
	player_stats = load("res://Assets/Resources/player_stats.tres")
	player_stats.connect("stat_changed", update_interface)
	update_interface(player_stats.stats)


func update_interface(stats):
	# update money
	score_label.text = "Money: %s" % stats["money"]
	# update hp bar
	hp_label.text = "%s/%s" % [stats["health"], stats["max_health"]]
	hp_bar.max_value = stats["max_health"]
	update_progress_bar(hp_bar, stats["health"], 0.05)
	# update xp
	xp_label.text = "Level %s" % stats["level"]
	xp_bar.max_value = stats["xp_needed"]
	update_progress_bar(xp_bar, stats["xp"], 0.5)


func _unhandled_input(event):
	if event.is_action_pressed("pause") and handle_input:
		self.paused = not paused
		get_viewport().set_input_as_handled()

func on_pause_mode_change(value):
	scene_tree.paused = value
	pause_overlay.visible = value
	return value

# this functions smoothly changes the value of a progress bar
func update_progress_bar(progressbar, end, duration):
	var tween = get_tree().create_tween()
	tween.tween_property(progressbar, "value", end, duration)


func _on_player_level_up():
	handle_input = false
	upgrade_overlay.new_shop()
	upgrade_overlay.visible = true
	scene_tree.paused = true

func upgraded(node: Button):
	
	handle_input = true
	upgrade_overlay.visible = false
	scene_tree.paused = false
