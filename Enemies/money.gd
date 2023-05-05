extends Area2D

var money_value := 1
var player_stats
@onready var sound = $PickUpSound

func _ready():
	player_stats = null
	player_stats = load("res://Assets/Resources/player_stats.tres")
	

func _on_area_entered(area):
	if area.is_in_group("player"):
		player_stats.add_stat("money", money_value, true)
		sound.play()
		visible = false
		await get_tree().create_timer(0.5).timeout
		queue_free()

