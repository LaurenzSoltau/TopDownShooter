extends Control

var player_stats
@onready var score_label: Label = get_node("ScoreLabel")


func _ready():
	player_stats = null
	player_stats = load("res://Assets/Resources/player_stats.tres")
	score_label.text = score_label.text % player_stats.stats["money"]
