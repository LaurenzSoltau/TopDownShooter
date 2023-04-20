extends Control

@onready var scene_tree: = get_tree()
@onready var pause_overlay: ColorRect = get_node("PauseOverlay")
@onready var score_label: Label = get_node("money")
@onready var hp_label: Label = get_node("hp")
@onready var hp_bar: ProgressBar = get_node("hp_bar")

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
	score_label.text = "Money: %s" % stats["money"]
	hp_label.text = "%s/%s" % [stats["health"], stats["max_health"]]
	hp_bar.max_value = stats["max_health"]
	hp_bar.value = stats["health"]


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.paused = not paused
		get_viewport().set_input_as_handled()

func on_pause_mode_change(value):
	scene_tree.paused = value
	pause_overlay.visible = value
	return value




