extends Area2D

@export var xp_value: int = 5
var player_stats
@onready var collect_sound = $CollectSound

func _ready():
	player_stats = null
	player_stats = load("res://Assets/Resources/player_stats.tres")


func _on_area_entered(area):
	if area.is_in_group("player"):
		player_stats.add_stat("xp", xp_value, true)
		collect_sound.play()
		visible = false
		await get_tree().create_timer(0.5).timeout
		queue_free()
