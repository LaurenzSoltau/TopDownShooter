extends ColorRect


var stat_elements = []

var player_stats: Resource

func _ready():
	player_stats = null
	player_stats = load("res://Assets/Resources/player_stats.tres")
	player_stats.connect("stat_changed", update_stats)
	for child in $stats/VBoxContainer.get_children():
		stat_elements.append(child)
	for child in $stats/VBoxContainer2.get_children():
		stat_elements.append(child)
	update_stats(player_stats.stats)


func load():
	$AnimationPlayer.current_animation = "SlideIn"
	$AnimationPlayer.play()
	get_tree().paused = true

func deload():
	$AnimationPlayer.current_animation = "SlideOut"
	$AnimationPlayer.play()
	get_tree().paused = false

func update_stats(stats):
	for stat in stat_elements:
		if stat.stat_key == null:
			return
		if stat.stat_key in stats:
			stat.change_value(stats[stat.stat_key])

