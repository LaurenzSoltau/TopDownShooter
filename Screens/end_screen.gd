extends Control

var player_stats = preload("res://Assets/Resources/player_stats.tres")
@onready var score_label: Label = get_node("ScoreLabel")


func _ready():
	score_label.text = score_label.text % player_stats.stats["money"]
